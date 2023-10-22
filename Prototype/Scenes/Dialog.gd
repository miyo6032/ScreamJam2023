extends Label

class_name Dialog

var pc: float

func _ready():
    visible_ratio = 0.0    
    
func show_dialog(dialog, time):
    visible_ratio = 0.0    
    text = dialog
    var tween = get_tree().create_tween()
    tween.tween_property(self, "visible_ratio", 1.0, time)
