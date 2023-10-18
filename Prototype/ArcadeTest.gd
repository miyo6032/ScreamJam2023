extends MeshInstance3D

func _ready():
    var viewport = $SubViewport
    $Screen.get_surface_override_material(0).albedo_texture = viewport.get_texture()
