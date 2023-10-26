extends Path3D

@export var gumkid: Gumkid
@export var path_follow: PathFollow3D

func _ready():
    var tween = create_tween()
    gumkid.set_speed(1)
    tween.tween_property(path_follow, "progress_ratio", 1, 25)
