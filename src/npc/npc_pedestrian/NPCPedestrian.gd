extends Node3D
class_name NPCPedestrian


@onready var down_raycast: RayCast3D = $DownRayCast3D
@onready var front_raycast: RayCast3D = $FrontRayCast3D
@onready var left_raycast: RayCast3D = $LeftRayCast3D

const GRAVITY: float = 1
const WALK_SPEED: float = 1.1


func _physics_process(delta: float) -> void:
	if not down_raycast.is_colliding():
		global_position.y -= GRAVITY * delta
	global_position -= global_transform.basis.z * WALK_SPEED * delta
	
	if front_raycast.is_colliding():
		front_raycast.get_collider().occupied = true
		global_rotation.y += deg_to_rad(-90) if left_raycast.is_colliding() else deg_to_rad(90)
