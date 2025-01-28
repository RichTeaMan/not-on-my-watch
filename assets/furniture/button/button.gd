class_name FurnitureButton extends Node2D

@export var button_id: String = "Button"

@onready var area: Area2D = %button_area

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

    if Input.is_action_just_pressed("action"):
        var character_body = Global.fetch_player_body()
        if area.overlaps_body(character_body):
            Log.info("Button '%s' pressed" % [ button_id ])
            Global.button_pressed(button_id)
