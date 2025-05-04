extends Node3D
signal player_entered

@onready var area: Area3D = $Area3D
const WAIT_TIME: int = 3000 # msec
var _stationary_time: int = 0


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if Global.player.linear_velocity.length() < 0.1 and \
		Time.get_ticks_msec() - _stationary_time > WAIT_TIME:
			emit_signal("player_entered")
			set_physics_process(false)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		set_physics_process(true)
		_stationary_time = Time.get_ticks_msec()


func _on_body_exited(body: Node) -> void:
	if body is Player:
		set_physics_process(false)


func enable() -> void:
	Util.reconnect(area.body_entered, _on_body_entered)
	Util.reconnect(area.body_exited, _on_body_exited)
	area.set_deferred("monitoring", true)
	visible = true
	MissionManager.curr_objective = global_position


func disable() -> void:
	Util.deconnect(area.body_entered, _on_body_entered)
	Util.deconnect(area.body_exited, _on_body_exited)
	area.set_deferred("monitoring", false)
	visible = false
