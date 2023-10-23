extends Node3D

@onready var anim_tree := $AnimationTree

@export var audio_player: AudioStreamPlayer3D
@export var step_sounds: Array[AudioStream]

var rng = RandomNumberGenerator.new()

func _ready():
    $AnimationTree.active = true

func set_speed(speed):
    anim_tree.set("parameters/conditions/idle", speed == 0)
    anim_tree.set("parameters/conditions/run", speed != 0)

func scream():
    anim_tree.set("parameters/conditions/scream", true)
    await get_tree().create_timer(3).timeout
    anim_tree.set("parameters/conditions/scream", false)

func scare():
    anim_tree.set("parameters/conditions/scare", true)

func play_step():
    audio_player.stream = step_sounds[rng.randi_range(0, step_sounds.size() - 1)]
    audio_player.play()
