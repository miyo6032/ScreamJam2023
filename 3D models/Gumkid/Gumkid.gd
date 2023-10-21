extends Node3D

@onready var anim_tree := $AnimationTree

func set_speed(speed):
    anim_tree.set("parameters/conditions/idle", speed == 0)
    anim_tree.set("parameters/conditions/run", speed != 0)
