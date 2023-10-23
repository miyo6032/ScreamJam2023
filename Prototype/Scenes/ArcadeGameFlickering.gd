extends MeshInstance3D

@export var screen: MeshInstance3D
@export var viewport: SubViewport

func _ready():
    screen.get_surface_override_material(0).emission_texture = viewport.get_texture()
