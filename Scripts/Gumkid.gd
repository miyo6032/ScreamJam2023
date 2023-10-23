extends Node3D

class_name Gumkid

signal capture

@onready var model := $GumkidModel

func _on_capture_area_body_entered(body):
    capture.emit()

func set_speed(speed):
    model.set_speed(speed)

func set_inactive():
    $CaptureArea.monitoring = false
    visible = false

func set_active():
    $CaptureArea.monitoring = true

func set_scream():
    model.scream()

func set_scare():
    model.scare()
