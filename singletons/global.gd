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

var character_body

func _ready() -> void:
    get_tree().get_root().size_changed.connect(_on_resize)
    _on_resize()

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

func _on_resize():
    var window_size = DisplayServer.window_get_size()
    #get_viewport().get_visible_rect().size
    var new_scale := float(window_size.x) / INTERNAL_RESOLUTION_WIDTH
    get_window().content_scale_factor = new_scale
    Log.info("Window [%s] resized with scale %s" % [window_size, new_scale])
