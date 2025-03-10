class_name Reactor extends Node2D

@export var MAX_POWER = 100
@export var TICK_TIME = 1
@export var MAX_CRITICAL_LEVEL = 10

@onready var power_label: Label = %power_label
@onready var critical_label: Label = %critical_label
@onready var speech_bubble: SpeechBubble = %speech_bubble

var powerLevel = MAX_POWER
var tick_delta = 0

var current_power_drain = 0
var critical_level = 0

func _ready() -> void:
    Global.on_button_pressed.connect(_on_button_pressed)
    Global.on_increment_power_consumption.connect(_on_increment_power_consumption)

func _process(delta: float) -> void:
    tick_delta += delta
    if tick_delta < TICK_TIME:
        return
    tick_delta -= TICK_TIME
    speech_bubble.message = "Draw power: %s" % [ current_power_drain ]

    if current_power_drain > MAX_POWER:
        critical_level += 1
        if critical_level >= MAX_CRITICAL_LEVEL:
            Log.info("Game over: reactor critical")
            Global.game_over("The reactor overheated")
    elif critical_level > 0:
        critical_level -= 1
    critical_label.text = "Criticality: %s/%s" % [critical_level, MAX_CRITICAL_LEVEL]
    speech_bubble.message += "\nCriticality: %s/%s" % [critical_level, MAX_CRITICAL_LEVEL]

func is_in_danger() -> bool:
    return (MAX_CRITICAL_LEVEL * 0.75) <= critical_level

func _on_button_pressed(button_id: String):
    if button_id != "reactor":
        return
    powerLevel = MAX_POWER

func power_drain(p_current_power_drain: int):
    var old_current_power_drain = current_power_drain
    current_power_drain = p_current_power_drain
    power_label.text = "Power draw: %s" % [ current_power_drain ]
    if current_power_drain > MAX_POWER:
        power_label.text = "Draw power: %s" % [ current_power_drain ]
        if old_current_power_drain != p_current_power_drain && randi() % 4 == 0:
            UI.add_comm_message("Careful! Reactor is overloaded!")

func _on_increment_power_consumption(power):
    power_drain(current_power_drain + power)
