extends Path3D

@onready var path_follow := $PathFollow3D

func _ready():
    var tween = get_tree().create_tween()
    tween.tween_property(path_follow, "progress_ratio", 1, 5.0)
