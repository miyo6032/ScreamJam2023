extends Node2D

signal game_crash
signal game_start

@onready var camera := $Camera2D
@onready var player := $Player
@onready var path_follow := $Path2D/PathFollow2D
@onready var starting_screen = $Camera2D/UserInterface/StartingScreen

@export var camera_target: Marker2D

var player_died = false
var enabled = true

func _physics_process(delta):
    if !enabled:
        return
    if Input.is_action_just_released("ui_accept") and starting_screen.visible:
        if player_died:
            get_tree().reload_current_scene()
        else:
            game_start.emit()
            starting_screen.hide()
            player.enabled = true
            var tween = create_tween()
            tween.tween_property(path_follow, "progress_ratio", 1, 13.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

func _crash_after_delay():
    if enabled:
        game_crash.emit()
        enabled = false

func _process(delta):
    if !enabled:
        return
    camera.global_position = camera_target.global_position

func _on_game_crash():
    $Camera2D/UserInterface/CrashScreen.show()

func _on_enemy_body_entered(body):
    starting_screen.show()
    $Camera2D/UserInterface/StartingScreen/Title.text = "You Died!"
    $Camera2D/UserInterface/StartingScreen/PressEnter.text = "Press Enter to try again"
    player.enabled = false
    player_died = true

func _on_area_2d_body_entered(body):
    _crash_after_delay()
