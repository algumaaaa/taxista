extends SpecialMission


var has_compass: bool = false:
	set(value):
		if value:
			Global.ui.compass.visible = true
			_in_progress = true
			start_point.disable()
			end_point.enable()
			Util.reconnect(end_point.player_entered, _on_end_point_entered)


func assign() -> void:
	Global.ui.compass.visible = false
	_assigned = true
	# Entering car jolt
	await get_tree().create_timer(2).timeout
	Global.player.jolt_vehicle(.5)
	await get_tree().create_timer(2).timeout
	Global.player.jolt_vehicle(-.5)
	await get_tree().create_timer(2).timeout
	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "inicio")
