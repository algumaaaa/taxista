@tool
extends StaticBody3D
class_name LaneWall

enum Wall { SET, ALL, LEFT, RIGHT }
enum Visibility { SET, TRUE, FALSE, RESET }

@export var enabled_walls: Wall = Wall.SET:
	set(value):
		match value:
			Wall.ALL:
				$CollisionShape3D.disabled = false
				$CollisionShape3D2.disabled = false
			Wall.LEFT:
				$CollisionShape3D.disabled = false
				$CollisionShape3D2.disabled = true
			Wall.RIGHT:
				$CollisionShape3D.disabled = true
				$CollisionShape3D2.disabled = false

@export var debug_visibility_walls: Visibility = Visibility.SET:
	set(value):
		match value:
			Visibility.TRUE:
				$MeshInstance3D.visible = ! $CollisionShape3D.disabled
				$MeshInstance3D.mesh.size = $CollisionShape3D.shape.size
				$MeshInstance3D.position = $CollisionShape3D.position
				$MeshInstance3D2.visible = ! $CollisionShape3D2.disabled
				$MeshInstance3D2.mesh.size = $CollisionShape3D2.shape.size
				$MeshInstance3D2.position = $CollisionShape3D2.position
			Visibility.FALSE:
				$MeshInstance3D.visible = false
				$MeshInstance3D2.visible = false
			Visibility.RESET:
				set("debug_visibility_walls", Visibility.FALSE)
				set("debug_visibility_walls", Visibility.TRUE)


func _ready() -> void:
	$MeshInstance3D.mesh = _create_unique_mesh($MeshInstance3D.mesh)
	$MeshInstance3D2.mesh = _create_unique_mesh($MeshInstance3D2.mesh)
	$CollisionShape3D.shape = _create_unique_shape($CollisionShape3D.shape)
	$CollisionShape3D2.shape = _create_unique_shape($CollisionShape3D2.shape)


func _create_unique_mesh(base_mesh: BoxMesh) -> Mesh:
	var new_mesh := BoxMesh.new()
	new_mesh.size = base_mesh.size
	new_mesh.material = base_mesh.material
	return new_mesh


func _create_unique_shape(base_shape: BoxShape3D) -> BoxShape3D:
	var new_shape := BoxShape3D.new()
	new_shape.size = base_shape.size
	return new_shape
