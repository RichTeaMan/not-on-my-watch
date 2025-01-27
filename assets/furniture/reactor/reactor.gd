extends Node2D

@export var MAX_POWER = 100
@export var POWER_DRAIN_FRAMES = 10

@onready var powerLabel: Label = %power_label

var powerLevel = MAX_POWER
var frames = 0

var current_power_drain = 0

func _ready() -> void:
    Global.on_button_pressed.connect(_on_button_pressed)
    Global.on_increment_power_consumption.connect(_on_increment_power_consumption)

func _on_button_pressed(button_id: String):
    if button_id != "reactor":
        return
    powerLevel = MAX_POWER

func _on_increment_power_consumption(power):
    current_power_drain += power
    powerLabel.text = "Draw power: %s" % [ current_power_drain ]
    if current_power_drain > MAX_POWER:
        UI.add_comm_message("HELP! Reactor is overloaded!")
        powerLabel.text = "Draw power: %s OVERLOADED" % [ current_power_drain ]
