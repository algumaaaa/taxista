extends StaticBody3D
class_name CustomWall


var id: int = 0
@export var spawner: bool = true


func _ready() -> void:
	$MeshInstance3D.mesh = _create_unique_mesh($MeshInstance3D.mesh)
	$MeshInstance3D2.mesh = _create_unique_mesh($MeshInstance3D2.mesh)
	$CollisionShape3D.shape = _create_unique_shape($CollisionShape3D.shape)
	$CollisionShape3D2.shape = _create_unique_shape($CollisionShape3D2.shape)


func is_visible_to_player() -> bool:
	var _player_facing: Vector3 = Global.player.global_transform.basis.z
	if rad_to_deg(_player_facing.angle_to(global_position)) < 90.0:
		return true
	return false


func _create_unique_mesh(base_mesh: BoxMesh) -> Mesh:
	var new_mesh := BoxMesh.new()
	new_mesh.size = base_mesh.size
	new_mesh.material = base_mesh.material
	return new_mesh


func _create_unique_shape(base_shape: BoxShape3D) -> BoxShape3D:
	var new_shape := BoxShape3D.new()
	new_shape.size = base_shape.size
	return new_shape
