extends Node3D

@export var lightsToDisable: Array[Light3D]

@onready var dialog := $Control/Dialog

func _ready():
    $Player.look_in_direction(TAU * 0.5)
    $Player.enabled = false

func _on_arcade_game_game_crash():
    for light in lightsToDisable:
        light.visible = false
    $Player.enabled = true
    dialog.show_dialog("The power went out? Bruh.")
