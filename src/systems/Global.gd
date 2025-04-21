extends Node


var player: VehicleBody3D
var ui: Control
var scene: Node3D


func _ready() -> void:
	await scene.ready
	MissionManager.load_missions()
	MissionManager.assign(0)
	# Await lane registering TODO: this is unsafe probably
	await get_tree().get_root().get_node("MainNode3D").ready
	NpcManager._instance_vehicles()
	NpcManager.manage_vehicle_instancing()
