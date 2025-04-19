extends Control


func _ready() -> void:
	Global.ui = self


func _physics_process(delta: float) -> void:
	if not Global.player:
		return
	
	var _player_vel: String = str(Global.player.linear_velocity.length()).substr(0, 3)
	$PanelContainer/VBoxContainer/Label.text = "Velocity: %s" % _player_vel
	var _player_loc: String = str(Global.player.global_position)
	$PanelContainer/VBoxContainer/Label2.text = "Player Position: %s" % _player_loc
	
	if MissionManager.curr_mission:
		var _mission_start_loc: String = str(MissionManager.curr_mission.start_point.global_position)
		var _mission_end_loc: String = str(MissionManager.curr_mission.end_point.global_position)
		
		if MissionManager.curr_mission._in_progress:
			$PanelContainer/VBoxContainer/Label3.text = "Goal Position: %s" % _mission_end_loc
		else:
			$PanelContainer/VBoxContainer/Label3.text = "Goal Position: %s" % _mission_start_loc
		
		$PanelContainer/VBoxContainer/Label4.text = "Mission ID: %s" % str(MissionManager.curr_mission.id)
		var _mission_status: String = "Pick up" if not MissionManager.curr_mission._in_progress else "Drop off"
		$PanelContainer/VBoxContainer/Label5.text = "Mission Status: " + _mission_status
	
	
