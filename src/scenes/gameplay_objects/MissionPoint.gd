extends Node3D
signal player_entered

@onready var area: Area3D = $Area3D


func _ready() -> void:
	area.connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("player_entered")


func enable() -> void:
	area.set_deferred("monitoring", true)
	visible = true
	MissionManager.curr_objective = global_position


func disable() -> void:
	area.set_deferred("monitoring", false)
	visible = false
