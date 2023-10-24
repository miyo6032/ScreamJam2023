extends Node3D

@export var do_instant_events: bool
@export var lights_to_disable: Node3D
@export var exit_breaker_trigger: Area3D
@export var arcade_game: ArcadeGameLit
@export var gumkid: Gumkid
@export var screen_flash: AnimationPlayer
@export var path_follow: PathFollow3D
@export var scare_camera: Camera3D
@export var scare_light: Light3D
@export var dialog: Dialog
@export var arcade_static_audio: AudioStreamPlayer3D
@export var music_audio_player: AudioStreamPlayer
@export var sfx_player: AudioStreamPlayer
@export var pointer: ColorRect
@export var emission_objects: Array[MeshInstance3D]
@export var falling_arcade_trigger: Area3D

@export var arcade_music: AudioStream
@export var thunder: AudioStream
@export var background: AudioStream
@export var key_pickup: AudioStream
@export var switch_breaker: AudioStream
@export var breaker_fail: AudioStream

@onready var player: Player = $Player

var dialog_time = 0.0
var dialog_pause_time = 0.0

var movement_tween

var has_key: bool

func _ready():
#    player.look_in_direction(TAU * 0.25)
    player.enabled = false
    player.disable_flashlight()
    exit_breaker_trigger.monitoring = false
    gumkid.set_inactive()
    scare_light.visible = false
    pointer.visible = false
    falling_arcade_trigger.monitoring = false

    Console.add_command("spawn", _on_arcade_interactable_interacted)
    Console.add_command("crash", _on_arcade_game_game_crash)

    if !do_instant_events:
        dialog_time = 2.0
        dialog_pause_time = 2.0

func _on_arcade_game_game_start():
    music_audio_player.stream = arcade_music
    music_audio_player.play()

func _on_arcade_game_game_crash():
    music_audio_player.stop()
    sfx_player.stream = thunder
    sfx_player.play()

    screen_flash.play("thunder")

    lights_to_disable.visible = false

    for obj in emission_objects:
        var material: Material = obj.material_override
        material.emission_enabled = false
        
    await pause(1.5)
    player.enabled = true
    dialog.show_dialog("Oh, no, the power went out!", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    dialog.show_dialog("Time to get out my flashlight", dialog_time)

    await pause(dialog_time + dialog_pause_time)
    player.enable_flashlight()
    pointer.visible = true
    pause(1)

    music_audio_player.stream = background
    music_audio_player.play()

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
        sfx_player.stream = switch_breaker
        sfx_player.play()

        exit_breaker_trigger.monitoring = true

        arcade_game.set_flickering()
        arcade_game.set_interactable()

        dialog.show_dialog("Hmm, the power didn't turn back on", dialog_time)

        arcade_static_audio.play()
    else:
        sfx_player.stream = breaker_fail
        sfx_player.play()

        dialog.show_dialog("The breaker box has a lock... ", dialog_time)

        await pause(dialog_time + dialog_pause_time)
        dialog.show_dialog("Maybe the key would be in the office", dialog_time)

func _on_exit_breaker_trigger_body_entered(body):
    exit_breaker_trigger.set_deferred("monitoring", false)

    dialog.show_dialog("Why is the Gumkid arcade machine on?", dialog_time)

func _on_arcade_interactable_interacted():
    player.enabled = false
    screen_flash.play("flash")
    gumkid.set_scream()
    gumkid.visible = true

    player.enabled = true
    falling_arcade_trigger.monitoring = true

    await pause(5.0)
    gumkid.set_active()
    movement_tween = get_tree().create_tween()
    gumkid.set_speed(1)
    movement_tween.tween_property(path_follow, "progress_ratio", 1, 35)

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

    sfx_player.stream = key_pickup
    sfx_player.play()

    dialog.show_dialog("I got the key to the breaker box!", dialog_time)

