extends Label

class_name Dialog

var tween

func _ready():
    visible_ratio = 0.0    
    
func show_dialog(dialog, time):
    if tween:
        tween.kill()

    visible_ratio = 0.0    
    text = dialog
    tween = get_tree().create_tween()
    tween.tween_property(self, "visible_ratio", 1.0, time)
    tween.tween_callback(reset).set_delay(5.0)

func reset():
    visible_ratio = 0.0
