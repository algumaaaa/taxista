@tool
extends CustomWall
class_name SideWalkWall


enum Wall { SET, ALL, SIDE, FRONT }
@export var enabled_walls: Wall = Wall.SET:
	set(value):
		match value:
			Wall.ALL:
				$CollisionShape3D.disabled = false
				$CollisionShape3D2.disabled = false
			Wall.SIDE:
				$CollisionShape3D.disabled = false
				$CollisionShape3D2.disabled = true
			Wall.FRONT:
				$CollisionShape3D.disabled = true
				$CollisionShape3D2.disabled = false

enum Visibility { SET, TRUE, FALSE, RESET }
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

var occupied: bool = false:
	set(value):
		if value:
			last_time_occupied = Time.get_ticks_msec()


var last_time_occupied: int = 0
const UNNOCUPY_COOLDOWN: int = 2000 # msec


func _ready() -> void:
	super._ready()
	id = NpcManager.register_sidewalk(self)
