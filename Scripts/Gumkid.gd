extends Node3D

class_name Gumkid

@onready var model := $GumkidModel

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_capture_area_body_entered(body):
    print("captured!")

func set_speed(speed):
    model.set_speed(speed)

func set_inactive():
    $CaptureArea.monitoring = false
    visible = false

func set_active():
    $CaptureArea.monitoring = true

func set_scream():
    model.scream()
