extends Node2D

signal game_crash

@onready var camera := $Camera2D
@onready var player := $Player
@onready var path_follow := $Path2D/PathFollow2D
@onready var starting_screen = $Camera2D/UserInterface/StartingScreen

var player_died = false

func _unhandled_input(event):
    if event.is_action_pressed("ui_accept") and starting_screen.visible:
        if player_died:
            game_crash.emit()
        else:
            starting_screen.hide()
            player.enabled = true
            var tween = get_tree().create_tween()
            tween.tween_property(path_follow, "progress_ratio", 1, 10.0)
            var tween2 = get_tree().create_tween()
            tween2.tween_callback(func(): game_crash.emit()).set_delay(8)

func _process(delta):
    camera.position = player.position

func _on_game_crash():
    $Camera2D/UserInterface/CrashScreen.show()

func _on_enemy_body_entered(body):
    starting_screen.show()
    $Camera2D/UserInterface/StartingScreen/Title.text = "You Died!"
    $Camera2D/UserInterface/StartingScreen/PressEnter.text = "Press Enter to try again"
    player.enabled = false
    player_died = true
