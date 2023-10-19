extends CharacterBody2D

const SPEED = 300.0

var enabled = false

func _physics_process(delta):
    if !enabled:
        return
    
    var input_dir = Input.get_vector("left", "right", "forward", "back")
    if input_dir:
        velocity = input_dir * SPEED
    else:
        velocity = Vector2.ZERO

    move_and_slide()
