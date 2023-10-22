extends MeshInstance3D

class_name ArcadeGameLit

func _ready():
    $ArcadeGameScreen/Screen.get_surface_override_material(0).emission_texture = $ArcadeGameScreen/SubViewport.get_texture()
    $ArcadeInteractable.interactable = false

func set_flickering():
    $FlickeringScreen/Screen.get_surface_override_material(0).emission_texture = $FlickeringScreen/SubViewport.get_texture()

func set_interactable():
    $ArcadeInteractable.interactable = true
