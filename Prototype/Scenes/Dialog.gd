extends Label

var pc: float

func _ready():
    visible_ratio = 0.0    
    
func show_dialog(dialog):
    visible_ratio = 0.0    
    text = dialog
    var tween = get_tree().create_tween()
    tween.tween_property(self, "visible_ratio", 1.0, 2.0)
