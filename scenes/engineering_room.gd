extends Node2D

@export var ship_health: int = 3

@export var enemy_ship_count: int = 1

@onready var camera = %camera

@onready var shield: ConsumerSubsystem = %shield
@onready var engine: ConsumerSubsystem = %engine
@onready var weapons: ConsumerSubsystem = %weapons

@onready var fire_1_scene = load("res://assets/effects/fire_1.tscn")
@onready var fire_2_scene = load("res://assets/effects/fire_2.tscn")
@onready var fire_3_scene = load("res://assets/effects/fire_3.tscn")

var enemy_ships: Array[EnemyShip] = []


func _ready() -> void:
    Global.on_enemy_ship_state_changed.connect(_on_enemy_ship_state_changed)
    Global.on_attack_enemy.connect(_on_attack_enemy)
    Global.on_game_over.connect(_on_game_over)
    for i in range(0, enemy_ship_count):
        enemy_ships.append(EnemyShip.new())

func _process(delta: float) -> void:
    for enemy_ship in enemy_ships:
        enemy_ship.process(delta)
        
    if Input.is_action_just_pressed("ui_page_up"):
        camera.shake(1.0)

func ship_damage():
    ship_health -= 1
    camera.shake(0.5)
    spawn_fire(20)
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
