class_name CommsMessage extends MarginContainer

@export var message: String = "Test message": set = _set_message, get = _get_message

@onready var label: Label = %"message-label"

func _set_message(_message: String):
    label.text = _message

func _get_message() -> String:
    return label.text
