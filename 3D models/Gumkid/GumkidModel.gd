extends Node3D

@onready var anim_tree := $AnimationTree

func set_speed(speed):
    anim_tree.set("parameters/conditions/idle", speed == 0)
    anim_tree.set("parameters/conditions/run", speed != 0)

func scream():
    anim_tree.set("parameters/conditions/scream", true)
    await get_tree().create_timer(3).timeout
    anim_tree.set("parameters/conditions/scream", false)

func scare():
    anim_tree.set("parameters/conditions/scare", true)
