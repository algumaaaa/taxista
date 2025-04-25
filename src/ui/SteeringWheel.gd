extends Control


const STEER_MULTIPLIER: float = 200.0


#func _ready() -> void:
	#if not Global.player:
		#set_physics_process(false)


func _physics_process(delta: float) -> void:
	var _player_steer: float = Global.player.get_steering()
	$TextureRect.rotation_degrees = - _player_steer * STEER_MULTIPLIER
