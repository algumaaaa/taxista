extends VehicleBody3D
class_name NPCVehicle

@export var MAX_STEER: float = 0.3
@export var STEER_SPEED: float = 4.0
@export var ENGINE_POWER: int = 30
@export var BRAKE_POWER: float = 5.0

const TARGET_DIST_TO_RAY: float = 1.8

@onready var front_ray: RayCast3D = $FrontRayCast3D
@onready var left_ray: RayCast3D = $LeftRayCast3D
@onready var right_ray: RayCast3D = $RightRayCast3D
@onready var side_ray_arr: Array[RayCast3D] = [ $LeftRayCast3D, $RightRayCast3D ]


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var _desired_engine_force: float = 0.0
	var _desired_steer: float = 0.0
	var _desired_brake: float = 0.0
	
	if front_ray.is_colliding():
		if front_ray.get_collider() is LaneWall:
			#_desired_brake = BRAKE_POWER/5 if linear_velocity.length() > 3 else 0
			pass
		else:
			_desired_brake = BRAKE_POWER
	else:
		_desired_engine_force = ENGINE_POWER
	
	# Don't speed, TODO: check assigned lane for this later
	if linear_velocity.length() > 4:
		_desired_engine_force = 0
	
	# Slow car to a halt if velocity is low
	linear_damp = 1.0 if linear_velocity.length() < 0.5 else 0.0
	
	# ideal dist 1.9
	if right_ray.is_colliding():
		var right_dist: float = global_position.distance_to(right_ray.get_collision_point())
		if right_dist < TARGET_DIST_TO_RAY:
			_desired_steer = TARGET_DIST_TO_RAY*1.1 - right_dist #* MAX_STEER
			# Slow down if steering
			_desired_engine_force = max(_desired_engine_force - 20.0, 0.0)
	if left_ray.is_colliding():
		var left_dist: float = global_position.distance_to(left_ray.get_collision_point())
		if left_dist < TARGET_DIST_TO_RAY:
			_desired_steer = -(TARGET_DIST_TO_RAY*1.1 - left_dist) #* MAX_STEER
			_desired_engine_force = max(_desired_engine_force - 20.0, 0.0)
	
	set_engine_force(_desired_engine_force)
	set_steering(move_toward(steering, _desired_steer, STEER_SPEED * delta))
	set_brake(_desired_brake)
	
	#var _desired_engine_force: float = 0.0
	#
	#var _speed: float = transform.basis.x.dot(linear_velocity)
	#if Input.is_action_pressed("accelerate"):
		## If speed is positive, its accelerating; else its braking
		#if _speed >= 0:
			#_desired_engine_force = ENGINE_POWER * Input.get_action_strength("accelerate")
		#else:
			#_desired_engine_force = (ENGINE_POWER * BRAKE_POWER) * Input.get_action_strength("accelerate")
	#if Input.is_action_pressed("reverse"):
		## If speed is positive, its braking; else its reversing
		#if _speed >= 0:
			#_desired_engine_force = (-ENGINE_POWER * BRAKE_POWER) * Input.get_action_strength("reverse")
		#else:
			#_desired_engine_force = -ENGINE_POWER * Input.get_action_strength("reverse")
	#
