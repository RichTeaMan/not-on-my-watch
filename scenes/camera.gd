extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
@export var noise: FastNoiseLite

var trauma = 0.0  # Current shake strength.
var trauma_power = 3  # Trauma exponent. Use [2, 3].

var noise_y = 0

func _ready():
    noise.seed = randi()
    #noise.period = 4
    #noise.octaves = 2

func _process(delta):
    if trauma:
        trauma = max(trauma - decay * delta, 0)
        do_shake()
        #optional
    elif offset.x != 0 or offset.y != 0 or rotation != 0:
        lerp(offset.x,0.0,1)
        lerp(offset.y,0.0,1)
        lerp(rotation,0.0,1)

func shake(p_trauma: float):
    trauma = min(trauma + p_trauma, 1.0)

func do_shake():
    var amount = pow(trauma, trauma_power)
    noise_y += 1
    rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
    offset.x = max_offset.x * amount * noise.get_noise_2d(1000, noise_y)
    offset.y = max_offset.y * amount * noise.get_noise_2d(2000, noise_y)
