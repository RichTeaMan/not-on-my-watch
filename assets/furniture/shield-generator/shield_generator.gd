extends Node2D


@export var MAX_SHIELD: int = 100
@export var POWER_DRAIN_FRAMES = 10

@onready var powerLabel: Label = %power_label

var powerLevel = MAX_SHIELD
var frames = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.on_button_pressed.connect(_on_button_pressed)


func _process(delta: float) -> void:
    if powerLevel <= 0:
        return
    if frames >= POWER_DRAIN_FRAMES:
        powerLevel += -1
        frames = 0
    else:
        frames += 1
    
    powerLabel.text = "Power: %s/%s" % [ powerLevel, MAX_SHIELD ]

func _on_button_pressed(button_id: String):
    if button_id != "shield":
        return
    powerLevel = MAX_SHIELD
