extends Node2D

@export var MAX_POWER = 100
@export var POWER_DRAIN_FRAMES = 10

@onready var powerLabel: Label = %power_label

var powerLevel = MAX_POWER
var frames = 0

func _ready() -> void:
    Global.on_button_pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if powerLevel <= 0:
        return
    if frames >= POWER_DRAIN_FRAMES:
        powerLevel += -1
        if powerLevel == MAX_POWER * 0.2:
            UI.add_comm_message("HELP! Reactor is running low!")
        frames = 0
    else:
        frames += 1
    
    powerLabel.text = "Power: %s/%s" % [ powerLevel, MAX_POWER ]


func _on_button_pressed(button_id: String):
    if button_id != "reactor":
        return
    powerLevel = MAX_POWER
