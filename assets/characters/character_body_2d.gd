extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

@export var SPEED = 64.0

func _process(_delta):
    if Input.is_action_pressed("ui_right"):
        _animated_sprite.play("walk_right")
    elif Input.is_action_pressed("ui_left"):
        _animated_sprite.play("walk_left")
    elif Input.is_action_pressed("ui_up"):
        _animated_sprite.play("walk_up")
    elif Input.is_action_pressed("ui_down"):
        _animated_sprite.play("walk_down")
    else:
        _animated_sprite.stop()
    var direction_x := Input.get_axis("ui_left", "ui_right")
    if direction_x:
        velocity.x = direction_x * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
    var direction_y := Input.get_axis("ui_up", "ui_down")
    if direction_y:
        velocity.y = direction_y * SPEED
    else:
        velocity.y = move_toward(velocity.y, 0, SPEED)

    move_and_slide()
