extends Node2D

signal on_button_pressed(button_id)
signal on_enemy_ship_attacked()
signal on_enemy_ship_state_changed(enemyShipState)
signal on_increment_power_consumption(power)
signal on_attack_enemy()
signal on_game_over(reason)
signal on_soda_ready()

var character_body

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

func attack_enemy() -> void:
    on_attack_enemy.emit()

func soda_ready() -> void:
    on_soda_ready.emit()
