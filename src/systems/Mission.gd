class_name Mission
extends Node

signal mission_finished

@export var start_point: Node3D
@export var end_point: Node3D
var id: int = 0
var _assigned: bool = false
var _in_progress: bool = false
var dialogue: Resource


func _ready() -> void:
	#if not start_point or end_point:
		#push_error("Mission %s without start or end point" % name)
	add_to_group("Mission")
	start_point.disable()
	end_point.disable()


func assign() -> void:
	_assigned = true
	start_point.enable()
	Util.reconnect(start_point.player_entered, _on_start_point_entered)


func _on_start_point_entered() -> void:
	Util.reconnect(end_point.player_entered, _on_end_point_entered)
	_in_progress = true
	end_point.enable()
	start_point.disable()
	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "inicio")


func _on_end_point_entered() -> void:
	_in_progress = false
	_assigned = false
	end_point.disable()
	emit_signal("mission_finished")
