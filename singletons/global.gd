extends Node2D

signal on_button_pressed(button_id)

var character_body

func register_player_body(character_body: CharacterBody2D) -> void:
    self.character_body = character_body

func fetch_player_body() -> CharacterBody2D:
    return self.character_body

func button_pressed(button_id: String) -> void:
    on_button_pressed.emit(button_id)
