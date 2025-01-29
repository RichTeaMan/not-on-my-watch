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
            EnemyShipState.IDLE:
                timeToStateChange = randi_range(5, 12)
                state = randInitialState()
            _: # always go to idle state for some player down time
                timeToStateChange = randi_range(2, 7)
                state = EnemyShipState.IDLE
        Global.enemy_ship_state_changed(state)
        Log.info("%s - %s seconds" % [EnemyShipState.keys()[state], timeToStateChange])

func randInitialState() -> EnemyShipState:
    var possible_states = [
        EnemyShipState.PREPARING_ATTACK,
        EnemyShipState.PREPARING_MISSILES
    ]
    return possible_states.pick_random()

func _on_attack_enemy():
    pass
