extends CharacterBody3D

const STOP_SPEED = 8.0
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
const BOB_FREQ = 2.0
const BOB_AMP = 0.1
var bob_progress = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
    if event is InputEventMouseButton:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    elif event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
        neck.rotate_y(-event.relative.x * SENSITIVITY)
        camera.rotate_x(-event.relative.y * SENSITIVITY)
        camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta

    var speed = 0
    if Input.is_action_pressed("sprint"):
        speed = SPRINT_SPEED
    else:
        speed = WALK_SPEED

    var input_dir = Input.get_vector("left", "right", "forward", "back")
    var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = lerp(velocity.x, direction.x * speed, delta * STOP_SPEED)
        velocity.z = lerp(velocity.z, direction.z * speed, delta * STOP_SPEED)

    bob_progress += delta * velocity.length() * float(is_on_floor())
    camera.transform.origin = headbob()

    move_and_slide()

func headbob():
    var pos = Vector3.ZERO
    pos.y = sin(bob_progress * BOB_FREQ) * BOB_AMP
    pos.x = sin(bob_progress * BOB_FREQ * 0.5) * BOB_AMP
    return pos
    
