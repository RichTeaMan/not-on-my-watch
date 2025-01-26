class_name CommsMessage extends MarginContainer

@export var message: String = "Test message": set = _set_message, get = _get_message
@export var expiry_time_seconds: int = 5

@onready var label: Label = %"message-label"

var total_delta: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    total_delta += delta
    if total_delta > expiry_time_seconds:
        queue_free()

func _set_message(_message: String):
    label.text = _message

func _get_message() -> String:
    return label.text
