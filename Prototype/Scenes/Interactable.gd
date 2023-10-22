extends StaticBody3D

class_name Interactable

signal interacted

@export var interactable: bool = true

func on_interact_enter():
    print("enter!")
    
func on_interact_exit():
    print("exit!")

func on_interact():
    interacted.emit()
