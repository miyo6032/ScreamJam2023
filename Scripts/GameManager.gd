extends Node3D

@export var do_instant_events: bool
@export var lightsToDisable: Array[Light3D]
@export var exit_breaker_trigger: Area3D

@onready var dialog := $Control/Dialog

var dialog_time = 0.0
var dialog_pause_time = 0.0

func _ready():
    $Player.look_in_direction(TAU * 0.5)
    $Player.enabled = false
    $Player.disable_flashlight()
    exit_breaker_trigger.monitoring = false

    if !do_instant_events:
        dialog_time = 2.0
        dialog_pause_time = 2.0

func _on_arcade_game_game_crash():
    for light in lightsToDisable:
        light.visible = false
        
    await pause(1.5)
    $Player.enabled = true
    dialog.show_dialog("The power went out? Bruh.", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    dialog.show_dialog("Time to get out my flashlight", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    $Player.enable_flashlight()
    pause(1)

    dialog.show_dialog("I was so close to beating Gumkid!", dialog_time)
    await pause(dialog_time + dialog_pause_time)

    dialog.show_dialog("No way am I stopping now!", dialog_time)
    await pause(dialog_time + dialog_pause_time)

    dialog.show_dialog("If I can find the breaker box...", dialog_time)
    await pause(dialog_time + dialog_pause_time)

    dialog.show_dialog("I might be able to restore the power", dialog_time)
    await pause(dialog_time + dialog_pause_time)

func pause(time):
    return get_tree().create_timer(time).timeout

func _on_electrical_box_electric_box():
    exit_breaker_trigger.monitoring = true

    dialog.show_dialog("Hmm, the power didn't turn back on", dialog_time)

func _on_arcade_flicker_trigger_body_entered(_body):
    exit_breaker_trigger.monitorable = false

    dialog.show_dialog("Why is the Gumkid arcade machine flickering?", dialog_time)
