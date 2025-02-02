@tool
extends ConsumerSubsystem

@export var TICK_TIME = 1
@export var MAX_CHARGE_LEVEL = 10

@onready var charge_label: Label = %charge_label

var tick_delta = 0.0
var charge_level: int = 0

func _ready() -> void:
    super._ready()
    if !Engine.is_editor_hint():
        speech_bubble.message = ""

func _process(delta: float) -> void:
    
    # because sometimes godot does jokes
    button.display_sprite = false
    button.collision_area.x = 60

    if Engine.is_editor_hint():
        speech_bubble.message = "soda bubble"
        return
    
    super._process(delta)
    tick_delta += delta
    if tick_delta < TICK_TIME:
        return
    tick_delta -= TICK_TIME
    if super.get_enabled_state():
        charge_level += 1
        if charge_level >= MAX_CHARGE_LEVEL:
            Global.soda_ready()
            is_enabled = false
            charge_level = 0
        speech_bubble.message = "Power usage: %s\nSoda progress: %s/%s" % [ POWER_USAGE, charge_level, MAX_CHARGE_LEVEL ]
        charge_label.text = "Charge: %s/%s" % [charge_level, MAX_CHARGE_LEVEL]
