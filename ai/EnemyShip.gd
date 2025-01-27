class_name EnemyShip

enum EnemyShipState {
    IDLE,
    PREPARING_ATTACK,
    ATTACKING,
    VULNERABLE
}

var timeMsToStateChange: float = 0.0
var state: EnemyShipState = EnemyShipState.IDLE

func process(delta: float):
    timeMsToStateChange -= delta
    if timeMsToStateChange < 0.0:
        if state == EnemyShipState.ATTACKING:
            Global.enemy_ship_attacked()
        timeMsToStateChange = randi_range(1, 10)
        match state:
            EnemyShipState.PREPARING_ATTACK:
                state = EnemyShipState.ATTACKING
            _:
                state = randInitialState()
        Global.enemy_ship_state_changed(state)
        print(state)

func randInitialState() -> EnemyShipState:
    match randi() % 3:
        0:
            return EnemyShipState.IDLE
        1:
            return EnemyShipState.PREPARING_ATTACK
        2:
            return EnemyShipState.VULNERABLE
        _:
            return EnemyShipState.IDLE
