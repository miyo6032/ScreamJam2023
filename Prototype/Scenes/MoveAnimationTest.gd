extends Path3D

@onready var gumkid := $PathFollow3D/RotationFix/gkid_run
@onready var path_follow := $PathFollow3D

func _ready():
    var tween = get_tree().create_tween()
    gumkid.set_speed(1)
    tween.tween_property(path_follow, "progress_ratio", 0.5, 5.0)
    tween.tween_callback(gumkid.set_speed.bind(0))
    tween.tween_callback(gumkid.set_speed.bind(1)).set_delay(2)
    tween.tween_property(path_follow, "progress_ratio", 1.0, 5.0)
    tween.tween_callback(gumkid.set_speed.bind(0))
    
