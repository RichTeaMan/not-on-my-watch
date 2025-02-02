@tool
class_name SpeechBubble extends Node2D

var _message: String = ""
@export_multiline var message: String:
    get:
        return _message
    set(value):
        _message = value

var _size: Vector2 = Vector2(20, 20)
@export var size: Vector2:
    get:
        return _size
    set (value):
        _size = value

@onready var label: Label = %label
@onready var outer_container: MarginContainer = %outer_container
@onready var tail: TextureRect = %tail
@onready var ui_root: Control = %ui_root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    label.text = _message
    visible = _message.length() > 0
    outer_container.size = _size
    tail.position.y = outer_container.size.y
    tail.position.x = (outer_container.size.x * 0.5) - (tail.size.x * tail.scale.x * 0.5)
    ui_root.position.x = -outer_container.size.x * 0.5
    ui_root.position.y = -(outer_container.size.y + (tail.size.y * tail.scale.y))
