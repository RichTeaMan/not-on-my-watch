extends Node2D

@export var enemy_ship_count: int = 1

@onready var shield: ConsumerSubsystem = %shield
@onready var engine: ConsumerSubsystem = %engine
@onready var weapons: ConsumerSubsystem = %weapons

var enemy_ships: Array[EnemyShip] = []

func _ready() -> void:
    Global.on_enemy_ship_state_changed.connect(_on_enemy_ship_state_changed)
    Global.on_attack_enemy.connect(_on_attack_enemy)
    for i in range(0, enemy_ship_count):
        enemy_ships.append(EnemyShip.new())

func _process(delta: float) -> void:
    if Global.game_finished:
        process_mode = ProcessMode.PROCESS_MODE_DISABLED
        return
    for enemy_ship in enemy_ships:
        enemy_ship.process(delta)

func _on_enemy_ship_state_changed(enemy_ship_state: EnemyShip.EnemyShipState) -> void:
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_ATTACK:
        UI.add_comm_message("They're preparing to attack, raise shields!")
    if enemy_ship_state == EnemyShip.EnemyShipState.PREPARING_MISSILES:
        UI.add_comm_message("They've about to launch missiles, deploy afterburners!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.VULNERABLE:
        UI.add_comm_message("They're wide open, ready the weapons!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.ATTACKING:
        if shield.get_enabled_state():
            UI.add_comm_message("They hit our shield, ha!");
        else:
            UI.add_comm_message("We've been hit by lasers!")
    elif enemy_ship_state == EnemyShip.EnemyShipState.LAUNCHING_MISSILES:
        if engine.get_enabled_state():
            UI.add_comm_message("We dodged the missiles!");
        else:
            UI.add_comm_message("We've been hit by missiles!")

func _on_attack_enemy():
    UI.add_comm_message("We've hit them! That'll slow them down.")
