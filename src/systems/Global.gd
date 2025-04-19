extends Node


var player: VehicleBody3D
var ui: Control
var scene: Node3D


func _ready() -> void:
	await scene.ready
	MissionManager.load_missions()
	MissionManager.assign(0)
