extends Node2D  

class_name ScreenFlickerEffect

@onready var animator: AnimationPlayer = $AnimationPlayer

func play_flicker_animation():
    animator.play("flicker")
