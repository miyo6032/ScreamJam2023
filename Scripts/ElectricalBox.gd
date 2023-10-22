extends Interactable

signal electric_box

func on_interact():
    electric_box.emit()
