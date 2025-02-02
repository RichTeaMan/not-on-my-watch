@tool
extends ConsumerSubsystem

var tick_delta = 0.0
var charge_level: int = 0

func _ready() -> void:
    super._ready()
    if !Engine.is_editor_hint():
        speech_bubble.message = ""

func _process(delta: float) -> void:
    
    # because sometimes godot does jokes
    button.display_sprite = false
    button.collision_area.x = 96
    
    if Engine.is_editor_hint():
        return
    super._process(delta)
    speech_bubble.message = "Engine power usage: %s" % POWER_USAGE if is_enabled else ""
