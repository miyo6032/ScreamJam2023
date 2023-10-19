extends Node3D

const RAY_LENGTH = 1000.0

@export var collider: CollisionObject3D
@export var camera: Camera3D

var currentInteractable: Interactable

func _physics_process(delta):
    var space_state = get_world_3d().direct_space_state
    var viewport = get_viewport()
    var screen_center = viewport.get_visible_rect().position + viewport.get_visible_rect().size / 2
    var from = camera.project_ray_origin(screen_center)
    var to = from + camera.project_ray_normal(screen_center) * RAY_LENGTH
    var query = PhysicsRayQueryParameters3D.create(from, to)
    query.exclude = [collider]
    query.collision_mask = 0b00000000_00000000_00000000_00000010

    var result = space_state.intersect_ray(query)
    if !result.is_empty():
        if currentInteractable != result.collider && result.collider is Interactable:
            if currentInteractable != null:
                currentInteractable.on_interact_exit()
            currentInteractable = result.collider
            currentInteractable.on_interact_enter()
    elif currentInteractable != null:
        currentInteractable.on_interact_exit()
        currentInteractable = null

