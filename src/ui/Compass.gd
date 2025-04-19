extends Control


func _physics_process(delta: float) -> void:
	if not Global.player:
		return
	var _goal_pos: Vector3 = MissionManager.curr_objective
	var _player_forward: Vector3 = -Global.player.global_transform.basis.z
	
	var dir_to_goal: = (_goal_pos - Global.player.global_position).normalized()
	var angle_y = atan2(dir_to_goal.x, dir_to_goal.z)
	
	angle_y -= Global.player.global_rotation.y
	
	$ColorRect.rotation_degrees = -(rad_to_deg(angle_y) + 90)
