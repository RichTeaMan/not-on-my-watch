extends Node2D

const INTERNAL_RESOLUTION_WIDTH = 36.0 * 32.0

signal on_button_pressed(button_id)
signal on_enemy_ship_attacked()
signal on_enemy_ship_state_changed(enemyShipState)
signal on_increment_power_consumption(power)
signal on_weapon_ready()
signal on_attack_enemy()
signal on_game_over(reason)
signal on_soda_ready()
signal on_fade_play_screen(alpha)
signal on_start_game()
signal on_restart_game()
signal on_low_enemy_health()

var character_body

var start_game_time: float = 0
var end_game_time: float = 0
var game_completed = true

func _ready() -> void:
    get_tree().get_root().size_changed.connect(_on_resize)
    _on_resize()

func game_duration_seconds() -> int:
    var end_duration := Time.get_unix_time_from_system()
    if game_completed:
        end_duration = end_game_time
    return floori(end_duration - start_game_time)

func register_player_body(p_character_body: CharacterBody2D) -> void:
    self.character_body = p_character_body

func fetch_player_body() -> CharacterBody2D:
    return self.character_body

func button_pressed(button_id: String) -> void:
    on_button_pressed.emit(button_id)

func enemy_ship_attacked() -> void:
    on_enemy_ship_attacked.emit()

func enemy_ship_state_changed(enemyShipState: EnemyShip.EnemyShipState) -> void:
    on_enemy_ship_state_changed.emit(enemyShipState)

func increment_power_consumption(power: int) -> void:
    on_increment_power_consumption.emit(power)

func game_over(reason: String) -> void:
    game_completed = true
    end_game_time = Time.get_unix_time_from_system()
    on_game_over.emit(reason)

func weapon_ready() -> void:
    on_weapon_ready.emit()

func attack_enemy() -> void:
    on_attack_enemy.emit()

func soda_ready() -> void:
    on_soda_ready.emit()

## Fades the play screen. 0.0 is no fade, 1.0 is fully black.
func fade_play_screen(alpha: float) -> void:
    on_fade_play_screen.emit(alpha)

func start_game() -> void:
    game_completed = false
    start_game_time = Time.get_unix_time_from_system()
    on_start_game.emit()

func restart_game() -> void:
    game_completed = false
    start_game_time = Time.get_unix_time_from_system()
    on_restart_game.emit()

func low_enemy_health() -> void:
    on_low_enemy_health.emit()

func _on_resize():
    var window_size = DisplayServer.window_get_size()
    #get_viewport().get_visible_rect().size
    var new_scale := float(window_size.x) / INTERNAL_RESOLUTION_WIDTH
    get_window().content_scale_factor = new_scale
    Log.info("Window [%s] resized with scale %s" % [window_size, new_scale])
