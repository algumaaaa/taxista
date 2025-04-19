extends StaticBody3D


@onready var collision_wall: CollisionShape3D = $StopLightCollisionBody/CollisionShape3D2
@onready var light_arr: Array[SpotLight3D] = [ $RedSpotLight3D, $YellowSpotLight3D, $GreenSpotLight3D, $YellowSpotLight3D]
@export var stop_light_time: float = 2.0
@export var yellow_light_time: float = 2.0
const DEFAULT_ENERGY: float = 4.0
var _curr_light: int = 0


func _ready() -> void:
	for i in light_arr.size():
		if _curr_light == i:
			continue
		light_arr[i].light_energy = 0
	Util.reconnect($Timer.timeout, _on_timer_timeout)
	$Timer.start(stop_light_time)


func _on_timer_timeout() -> void:
	light_arr[_curr_light].light_energy = 0
	_curr_light = (_curr_light+1) % 4
	light_arr[_curr_light].light_energy = DEFAULT_ENERGY
	
	if light_arr[_curr_light].name in [ "RedSpotLight3D", "YellowSpotLight3D" ]:
		collision_wall.disabled = false
	else:
		collision_wall.disabled = true
	var _time: int = yellow_light_time if light_arr[_curr_light].name ==\
		 "YellowSpotLight3D" else stop_light_time
	$Timer.start(_time)
