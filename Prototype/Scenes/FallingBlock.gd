extends Node3D

var has_fallen = false

func _on_area_trigger_body_entered(body):
    if !has_fallen:
        var tween = get_tree().create_tween()
        tween.tween_property(self, "rotation", Vector3(0, 0, TAU * -0.25), 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
