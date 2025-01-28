extends Node2D

@export var MAX_POWER = 100
@export var TICK_TIME = 1
@export var MAX_CRITICAL_LEVEL = 10

@onready var power_label: Label = %power_label
@onready var critical_label: Label = %critical_label

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
    if current_power_drain > MAX_POWER:
        critical_level += 1
        if critical_level >= MAX_CRITICAL_LEVEL:
            print("Game over: reactor critical")
            Global.game_over("The reactor overheated")
    elif critical_level > 0:
        critical_level -= 1
    critical_label.text = "Criticality: %s/%s" % [critical_level, MAX_CRITICAL_LEVEL]

func _on_button_pressed(button_id: String):
    if button_id != "reactor":
        return
    powerLevel = MAX_POWER

func _on_increment_power_consumption(power):
    current_power_drain += power
    power_label.text = "Draw power: %s" % [ current_power_drain ]
    if current_power_drain > MAX_POWER:
        UI.add_comm_message("HELP! Reactor is overloaded!")
        power_label.text = "Draw power: %s OVERLOADED" % [ current_power_drain ]
