extends Control


const START_ROT: float = 45.0
const MAX_ROT: float = 220.0
const MIN_VEL: float = 0.0
const EXPECTED_MAX_VEL: float = 15.0


#func _ready() -> void:
	#if not Global.player:
		#set_physics_process(false)


func _physics_process(delta: float) -> void:
	var _player_vel: float = Global.player.linear_velocity.length()
	var _desired_rot: float = _map_range(_player_vel)
	$ColorRect.rotation_degrees = _desired_rot


func _map_range(input: float) -> float:
	return (input - MIN_VEL) / (EXPECTED_MAX_VEL - MIN_VEL) * (MAX_ROT - START_ROT) + START_ROT
