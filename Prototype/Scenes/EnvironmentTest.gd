extends Node3D

@export var lightsToDisable: Array[Light3D]

@onready var dialog := $Control/Dialog

func _ready():
    $Player.look_in_direction(TAU * 0.5)
    $Player.enabled = false
    $Player.disable_flashlight()

func _on_arcade_game_game_crash():
    for light in lightsToDisable:
        light.visible = false
        
    var dialog_time = 2.0

    pause(1.5)
    $Player.enabled = true
    dialog.show_dialog("The power went out? Bruh.", dialog_time)

    pause(dialog_time + 1)
    dialog.show_dialog("Time to get out my flashlight", dialog_time)

    pause(dialog_time + 1)
    $Player.enable_flashlight()
    pause(1)

    dialog.show_dialog("I was so close to beating Gumkid!", dialog_time)
    pause(dialog_time + 1)

    dialog.show_dialog("No way am I stopping now!", dialog_time)
    pause(dialog_time + 1)

func pause(time):
    await get_tree().create_timer(time).timeout
