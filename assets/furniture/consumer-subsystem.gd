class_name ConsumerSubsystem extends Node2D

@export var POWER_USAGE: int = 30
@export var SUBSYSTEM_ID: String

@onready var label: Label = %label
@onready var button: FurnitureButton = %button

@onready var speech_bubble: SpeechBubble = %speech_bubble

var is_enabled = false

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    Global.on_button_pressed.connect(_on_button_pressed)
    button.button_id = SUBSYSTEM_ID

func _process(_delta: float) -> void:
    label.text = "On PU: %s" % POWER_USAGE if is_enabled else "Off"

func _on_button_pressed(button_id: String):
    if button_id != SUBSYSTEM_ID:
        return
    is_enabled = !is_enabled
    var power_delta = POWER_USAGE if is_enabled else -POWER_USAGE
    #Global.increment_power_consumption(power_delta)

func get_current_draw() -> int:
    return POWER_USAGE if is_enabled else 0

func get_enabled_state() -> bool:
    return is_enabled
