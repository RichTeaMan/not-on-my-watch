extends Node2D


@export var MAX_POWER: int = 100
@export var POWER_DRAIN_FRAMES = 10

@onready var powerLabel: Label = %power_label

var powerLevel = MAX_POWER
var frames = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.on_button_pressed.connect(_on_button_pressed)


func _process(_delta: float) -> void:
    if powerLevel <= 0:
        return
    if frames >= POWER_DRAIN_FRAMES:
        powerLevel += -1
        frames = 0
    else:
        frames += 1
    
    powerLabel.text = "Power: %s/%s" % [ powerLevel, MAX_POWER ]

func _on_button_pressed(button_id: String):
    if button_id != "weapons":
        return
    powerLevel = MAX_POWER
