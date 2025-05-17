extends Control


const ROT_INTENSITY: float = 10.0
var to_rot: float = 0.0
var last_rot: float = 0.0
var last_inertia: float = 0.0


func _physics_process(delta: float) -> void:
	var p_steering: float = Global.player.get_steering()
	var p_speed: float = Global.player.transform.basis.x.dot(Global.player.linear_velocity)
	var desired_rot: float = (p_steering * p_speed) * ROT_INTENSITY
	to_rot = move_toward(last_rot, desired_rot, delta)

	
	var inertia: float = to_rot - last_rot
	#if inertia - last_inertia > 0.5:
		#to_rot += (inertia - last_inertia)
	#print(inertia)
	

	$ColorRect.rotation += deg_to_rad(to_rot)
	last_rot = rad_to_deg($ColorRect.rotation)
	last_inertia = inertia


	#inertia = desired_rot - last_rot
	#if desired_rot > last_rot:
		#desired_rot += inertia
	#if desired_rot < last_rot:
		#desired_rot += inertia
	##move_toward(inertia, 0, 0.1 * delta)
	#
	#print(inertia)
	#
	##print(desired_rot)
	##var use_rot := desired_rot
	##if desired_rot == 0:
		##use_rot = inertia
		
# -deg_to_rad(move_toward(last_rot, use_rot, 10 * delta))
