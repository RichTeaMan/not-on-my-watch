extends Node2D

@export var enemy_ship_count: int = 1

@onready var shield: ConsumerSubsystem = %shield

var enemy_ships: Array[EnemyShip] = []

func _ready() -> void:
    Global.on_enemy_ship_state_changed.connect(_on_enemy_ship_state_changed)
    Global.on_enemy_ship_attacked.connect(_on_enemy_ship_attacked)
    for i in range(0, enemy_ship_count):
        enemy_ships.append(EnemyShip.new())

func _process(delta: float) -> void:
    for enemy_ship in enemy_ships:
        enemy_ship.process(delta)

func _on_enemy_ship_state_changed(enemy_ship_state: EnemyShip.EnemyShipState) -> void:
    if enemy_ship_state == EnemyShip.EnemyShipState.ATTACKING:
        UI.add_comm_message("They're preparing to attack!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.VULNERABLE:
        UI.add_comm_message("They're wide open, ready the weapons!")

func _on_enemy_ship_attacked() -> void:
    if shield.get_enabled_state():
        UI.add_comm_message("They hit our shield, ha!");
    else:
        UI.add_comm_message("We've been hit!")
