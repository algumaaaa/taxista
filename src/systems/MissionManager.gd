extends Node

@export var mission_arr: Array[Mission]
var curr_mission: Mission
var curr_objective: Vector3


func load_missions() -> void:
	var _missions := get_tree().get_nodes_in_group("Mission")
	for i in _missions.size():
		mission_arr.push_back(_missions[i])
		_missions[i].id = i


func assign(index: int = 0) -> void:
	curr_mission = mission_arr[index]
	mission_arr[index].assign()
	Util.reconnect(mission_arr[index].mission_finished, _on_mission_finished)


func _on_mission_finished() -> void:
	if not curr_mission.id + 1 > mission_arr.size()-1:
		assign(curr_mission.id + 1)
