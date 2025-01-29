extends Node2D

enum Aliments {
    COLD,
    HOT,
    THIRSTY,
    HUNGRY,
    UNCOMFORTABLE
}

@export var ship_health: int = 3

@export var enemy_ship_count: int = 1

@onready var camera = %camera

@onready var shield: ConsumerSubsystem = %shield
@onready var engine: ConsumerSubsystem = %engine
@onready var weapons: ConsumerSubsystem = %weapons

@onready var fire_1_scene = load("res://assets/effects/fire_1.tscn")
@onready var fire_2_scene = load("res://assets/effects/fire_2.tscn")
@onready var fire_3_scene = load("res://assets/effects/fire_3.tscn")

var aliment_timer = 10.0

var second_timer = 1.0

var enemy_ships: Array[EnemyShip] = []

var ship_aliments: Array[Aliments] = []

var weapon_offline_seconds = 0

func _ready() -> void:
    Global.on_enemy_ship_state_changed.connect(_on_enemy_ship_state_changed)
    Global.on_attack_enemy.connect(_on_attack_enemy)
    Global.on_game_over.connect(_on_game_over)
    Global.on_soda_ready.connect(_on_soda_ready)
    for i in range(0, enemy_ship_count):
        enemy_ships.append(EnemyShip.new())
    
    UI.add_comm_message("They're coming, get ready")
    
    # dumb way to delay a message
    var tween = get_tree().create_tween()
    tween.tween_interval(3.0)
    tween.tween_callback(UI.add_comm_message.bind("Don't forget to start charging the weapons!"))

func _process(delta: float) -> void:
    for enemy_ship in enemy_ships:
        enemy_ship.process(delta)
    
    second_timer -= delta
    if second_timer <= 0.0:
        second_timer += 1.0
        if weapons.get_enabled_state():
            weapon_offline_seconds = 0
        else:
            weapon_offline_seconds += 1
        if weapon_offline_seconds % 10 == 0:
            UI.add_comm_message("We're not charging our weapons!")
    
    aliment_timer -= delta
    if aliment_timer <= 0.0:
        aliment_timer = randf_range(5.0, 15.0)
        if !ship_aliments.has(Aliments.THIRSTY):
            ship_aliments.append(Aliments.THIRSTY)
            UI.add_comm_message("Goodness, I'm thirsty. Maybe switch the soda machine on?")
    
    if Input.is_action_just_pressed("ui_page_up"):
        camera.shake(1.0)
    if Input.is_action_just_pressed("ui_page_down"):
        UI.add_comm_message("a new message")

func ship_damage():
    ship_health -= 1
    camera.shake(0.7)
    spawn_fire(20)
    if ship_health == 1:
        UI.add_comm_message("One more hit and we're done for!")
    if ship_health <= 0:
        Global.game_over("The ship was destroyed be enemy attacks")

func spawn_fire(fires_to_spawn: int):
    var tile_map: TileMapLayer = %tile_map_floors
    var floor_tiles = tile_map.get_used_cells_by_id(-1, Vector2i(1, 1))
    floor_tiles.shuffle()
    var fire_scenes = [ fire_1_scene, fire_2_scene, fire_3_scene ]
    var effects_node = %effects
    for i in range(0, fires_to_spawn):
        var tile: Vector2i = floor_tiles.pop_front()
        var position = tile_map.map_to_local(tile)
        var fire: Node2D = fire_scenes.pick_random().instantiate()
        effects_node.add_child(fire)
        fire.position = position

func _on_enemy_ship_state_changed(enemy_ship_state: EnemyShip.EnemyShipState) -> void:
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_ATTACK:
        UI.add_comm_message("They're preparing to attack, raise shields!")
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_MISSILES:
        UI.add_comm_message("They've about to launch missiles, deploy afterburners!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.VULNERABLE:
        UI.add_comm_message("They're wide open, ready the weapons!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.ATTACKING:
        if shield.get_enabled_state():
            UI.add_comm_message("They hit our shield, ha!");
        else:
            UI.add_comm_message("We've been hit by lasers!")
            ship_damage()
            
    elif enemy_ship_state == EnemyShip.EnemyShipState.LAUNCHING_MISSILES:
        if engine.get_enabled_state():
            UI.add_comm_message("We dodged the missiles!");
        else:
            UI.add_comm_message("We've been hit by missiles!")
            ship_damage()

func _on_attack_enemy():
    UI.add_comm_message("We've hit them! That'll slow them down.")

func _on_game_over(_reason: String) -> void:
    process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _on_soda_ready() -> void:
    if ship_aliments.has(Aliments.THIRSTY):
        ship_aliments.remove_at(ship_aliments.find(Aliments.THIRSTY))
    UI.add_comm_message("Ahh, delicious soda.")
