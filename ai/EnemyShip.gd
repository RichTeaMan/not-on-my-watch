class_name EnemyShip

enum EnemyShipState {
    IDLE,
    PREPARING_ATTACK,
    ATTACKING,
    PREPARING_MISSILES,
    LAUNCHING_MISSILES,
    VULNERABLE
}

var timeToStateChange: float = 0.0
var state: EnemyShipState = EnemyShipState.IDLE

func _init() -> void:
    state = EnemyShipState.IDLE
    timeToStateChange = 5.0
    Global.on_attack_enemy.connect(_on_attack_enemy)

func process(delta: float):
    timeToStateChange -= delta
    if timeToStateChange < 0.0:
        match state:
            EnemyShipState.PREPARING_ATTACK:
                state = EnemyShipState.ATTACKING
            EnemyShipState.PREPARING_MISSILES:
                state = EnemyShipState.LAUNCHING_MISSILES
            _:
                timeToStateChange = randi_range(5, 12)
                state = randInitialState()
        Global.enemy_ship_state_changed(state)
        print("%s - %s seconds" % [EnemyShipState.keys()[state], timeToStateChange])

func randInitialState() -> EnemyShipState:
    match randi() % 3:
        0:
            return EnemyShipState.IDLE
        1:
            return EnemyShipState.PREPARING_ATTACK
        2:
            return EnemyShipState.PREPARING_MISSILES
        _:
            return EnemyShipState.IDLE

func _on_attack_enemy():
    pass
