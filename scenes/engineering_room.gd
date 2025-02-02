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

@onready var camera: Camera2D = %camera

@onready var reactor: Reactor = %reactor
@onready var shield: ConsumerSubsystem = %shield
@onready var engine: ConsumerSubsystem = %engine
@onready var weapons: ConsumerSubsystem = %weapons

@onready var fire_1_scene = load("res://assets/effects/fire_1.tscn")
@onready var fire_2_scene = load("res://assets/effects/fire_2.tscn")
@onready var fire_3_scene = load("res://assets/effects/fire_3.tscn")

@onready var sound_missile_hit: AudioStreamPlayer = %sound_missile_hit
@onready var sound_missile_miss: AudioStreamPlayer = %sound_missile_miss
@onready var sound_shield_hit: AudioStreamPlayer = %sound_shield_hit
@onready var sound_laser: AudioStreamPlayer = %sound_laser

var aliment_timer = 10.0

var second_timer = 1.0

var enemy_ships: Array[EnemyShip] = []

var ship_aliments: Array[Aliments] = []

var weapon_offline_seconds = 0

var red_siren_active = false

func _ready() -> void:
    Global.on_enemy_ship_state_changed.connect(_on_enemy_ship_state_changed)
    Global.on_weapon_ready.connect(_on_weapon_ready)
    Global.on_game_over.connect(_on_game_over)
    Global.on_soda_ready.connect(_on_soda_ready)
    Global.on_fade_play_screen.connect(_on_fade_play_screen)
    Global.on_low_enemy_health.connect(_on_low_enemy_health)
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
    
    if reactor.is_in_danger():
        start_red_siren()
    else:
        stop_red_siren()
    
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
    if Input.is_action_just_pressed("ui_end"):
        red_siren_active = !red_siren_active
        red_siren()
    
    var report_camera_position = false
    if Input.is_action_pressed("camera_up"):
        report_camera_position = true
        camera.position.y -= 10
    if Input.is_action_pressed("camera_down"):
        report_camera_position = true
        camera.position.y += 10
    if Input.is_action_pressed("camera_left"):
        report_camera_position = true
        camera.position.x -= 10
    if Input.is_action_pressed("camera_right"):
        report_camera_position = true
        camera.position.x += 10
    if report_camera_position:
        Log.info("Camera position: [%s, %s]" % [ camera.position.x, camera.position.y ])

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
        var fire_position = tile_map.map_to_local(tile)
        var fire: Node2D = fire_scenes.pick_random().instantiate()
        effects_node.add_child(fire)
        fire.position = fire_position

func _on_enemy_ship_state_changed(enemy_ship_state: EnemyShip.EnemyShipState) -> void:
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_ATTACK:
        UI.add_comm_message("They're preparing to attack, raise shields!")
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_MISSILES:
        UI.add_comm_message("They've about to launch missiles, power the engines!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.VULNERABLE:
        UI.add_comm_message("They're wide open, ready the weapons!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.ATTACKING:
        if shield.get_enabled_state():
            UI.add_comm_message("They hit our shield, ha!");
            sound_shield_hit.play()
        else:
            UI.add_comm_message("We've been hit by lasers!")
            sound_laser.play()
            ship_damage()
            
    elif enemy_ship_state == EnemyShip.EnemyShipState.LAUNCHING_MISSILES:
        if engine.get_enabled_state():
            UI.add_comm_message("We dodged the missiles!");
            sound_missile_miss.play()
        else:
            UI.add_comm_message("We've been hit by missiles!")
            sound_missile_hit.play()
            ship_damage()

func _on_weapon_ready():
    # check debuffs
    var missed = false
    for aliment in ship_aliments:
        if randi() % 2 == 0:
            missed = true
            match aliment:
                Aliments.THIRSTY:
                    UI.add_comm_message("I missed! I'm just so dang thirsty...")
                _:
                    UI.add_comm_message("Whoops, I missed.")
        break
    if !missed:
        Global.attack_enemy()
        UI.add_comm_message("We've hit them! That'll slow them down.")

func _on_low_enemy_health():
    UI.add_comm_message("They're badly damaged! One more hit should finish them")

func _on_game_over(_reason: String) -> void:
    process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _on_soda_ready() -> void:
    if ship_aliments.has(Aliments.THIRSTY):
        ship_aliments.remove_at(ship_aliments.find(Aliments.THIRSTY))
    UI.add_comm_message("Ahh, delicious soda.")

## Fades the screen. 0.0 is no fade, 1.0 is fully black.
func _on_fade_play_screen(alpha: float) -> void:
    modulate.r = alpha
    modulate.g = alpha
    modulate.b = alpha

func start_red_siren():
    if red_siren_active:
        return
    red_siren_active = true
    red_siren()

func stop_red_siren():
    red_siren_active = false

func red_siren():
    if !red_siren_active:
        return
    
    var transition_time = 0.6
    var pause_time = 0.2
    
    var canvas_modulate: CanvasModulate = %canvas_modulate
    var tween = get_tree().create_tween()
    tween.parallel().tween_property(canvas_modulate, "color:g", 0, transition_time)
    tween.parallel().tween_property(canvas_modulate, "color:b", 0, transition_time)
    
    tween.chain().tween_interval(pause_time)
    
    tween.parallel().tween_property(canvas_modulate, "color:g", 1, transition_time)
    tween.parallel().tween_property(canvas_modulate, "color:b", 1, transition_time)
    
    tween.chain().tween_interval(pause_time)
    tween.tween_callback(red_siren)
    
