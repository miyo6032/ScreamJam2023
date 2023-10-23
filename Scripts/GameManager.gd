extends Node3D

@export var do_instant_events: bool
@export var lightsToDisable: Array[Light3D]
@export var exit_breaker_trigger: Area3D
@export var arcade_game: ArcadeGameLit
@export var gumkid: Gumkid
@export var screen_flash: AnimationPlayer
@export var path_follow: PathFollow3D
@export var scare_camera: Camera3D
@export var scare_light: Light3D
@export var dialog: Dialog
@export var flicker_screen: ScreenFlickerEffect
@export var flicker_screen_trigger: Area3D

@onready var player: Player = $Player

var dialog_time = 0.0
var dialog_pause_time = 0.0

var movement_tween

var has_key: bool

func _ready():
    # player.look_in_direction(TAU * 0.5)
    player.enabled = false
    player.disable_flashlight()
    exit_breaker_trigger.monitoring = false
    gumkid.set_inactive()
    scare_light.visible = false
    flicker_screen_trigger.monitoring = false

    Console.add_command("spawn", _on_arcade_interactable_interacted)
    Console.add_command("crash", _on_arcade_game_game_crash)
    Console.add_command("flicker", _on_arcade_flicker_trigger_body_entered.bind(null))

    if !do_instant_events:
        dialog_time = 2.0
        dialog_pause_time = 2.0

func _on_arcade_game_game_crash():
    for light in lightsToDisable:
        light.visible = false
        
    await pause(1.5)
    player.enabled = true
    dialog.show_dialog("Oh, no, the power went out!", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    dialog.show_dialog("Time to get out my flashlight", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    player.enable_flashlight()
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

func _on_electrical_box_interacted():
    if has_key:
        exit_breaker_trigger.monitoring = true

        arcade_game.set_flickering()
        arcade_game.set_interactable()

        dialog.show_dialog("Hmm, the power didn't turn back on", dialog_time)

        flicker_screen_trigger.monitoring = true
    else:
        dialog.show_dialog("The breaker box has a lock... ", dialog_time)

        await pause(dialog_time + dialog_pause_time)
        dialog.show_dialog("Maybe the key would be in the office", dialog_time)

func _on_arcade_trigger_body_entered(body):
    exit_breaker_trigger.set_deferred("monitoring", false)

    dialog.show_dialog("Why is the Gumkid arcade machine on?", dialog_time)

func _on_arcade_flicker_trigger_body_entered(_body):
    flicker_screen.play_flicker_animation()
    flicker_screen_trigger.set_deferred("monitoring", false)

func _on_arcade_interactable_interacted():
    player.enabled = false
    screen_flash.play("flash")
    gumkid.set_scream()
    gumkid.visible = true

    player.enabled = true

    await pause(5.0)
    gumkid.set_active()
    movement_tween = get_tree().create_tween()
    gumkid.set_speed(1)
    movement_tween.tween_property(path_follow, "progress_ratio", 1, 25)

func _on_gumkid_capture():
    gumkid.set_speed(0.0)
    gumkid.set_scare()
    movement_tween.kill()
    player.enabled = false
    scare_camera.current = true
    show_gameover_screen()
    scare_light.visible = true

func show_gameover_screen():
    screen_flash.play("game_over")    

    await pause(3)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_try_again_button_pressed():
    get_tree().reload_current_scene()

func _on_quit_button_pressed():
    get_tree().quit()


func _on_key_interacted():
    has_key = true

    dialog.show_dialog("I got the key to the breaker box!", dialog_time)


