extends Node2D

@onready var scene_def = preload("res://scenes/engineering-room.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.on_restart_game.connect(_on_restart_game)
    start_game()

func start_game():
    var scene = scene_def.instantiate()
    add_child(scene)
    return scene

func _on_restart_game() -> void:
    for c in get_children():
        c.queue_free()
    start_game()._on_start_game()
