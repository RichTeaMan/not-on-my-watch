@tool
class_name FurnitureButton extends Node2D

@export var button_id: String = "Button"

var _display_sprite: bool = true
@export var display_sprite: bool:
    get:
        return _display_sprite
    set(value):
        _display_sprite = value
        %button_sprite.visible = value
        %button_sprite.process_mode = ProcessMode.PROCESS_MODE_INHERIT if value else ProcessMode.PROCESS_MODE_DISABLED

var _collision_area: Vector2 = Vector2(20, 10)
@export var collision_area: Vector2:
    get:
        return _collision_area
    set(value):
        _collision_area = value
        _set_collision_area_size(_collision_area)

@onready var area: Area2D = %button_area

func _set_collision_area_size(area_size: Vector2):
    var collision_shape: CollisionShape2D = %button_area_collision_shape
    var shape: RectangleShape2D = collision_shape.shape
    shape.size = area_size

func _ready():
    %button_sprite.visible = display_sprite
    _set_collision_area_size(collision_area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    if Input.is_action_just_pressed("action"):
        var character_body = Global.fetch_player_body()
        if area.overlaps_body(character_body):
            Log.info("Button '%s' pressed" % [ button_id ])
            Global.button_pressed(button_id)
