extends VehicleBody3D
class_name Player

@export var MAX_STEER: float = 0.4
@export var STEER_SPEED: float = 2.0
@export var ENGINE_POWER: int = 30
@export var BRAKE_POWER: float = 2.0

@onready var camera := $Camera3D


func _ready() -> void:
	Global.player = self


func _physics_process(delta: float) -> void:
	var _desired_steer: float = Input.get_axis("steer_right", "steer_left") * MAX_STEER
	var _desired_engine_force: float = 0.0
	
	var _speed: float = transform.basis.x.dot(linear_velocity)
	if Input.is_action_pressed("accelerate"):
		# If speed is positive, its accelerating; else its braking
		if _speed >= 0:
			_desired_engine_force = ENGINE_POWER * Input.get_action_strength("accelerate")
		else:
			_desired_engine_force = (ENGINE_POWER * BRAKE_POWER) * Input.get_action_strength("accelerate")
	if Input.is_action_pressed("reverse"):
		# If speed is positive, its braking; else its reversing
		if _speed >= 0:
			_desired_engine_force = (-ENGINE_POWER * BRAKE_POWER) * Input.get_action_strength("reverse")
		else:
			_desired_engine_force = -ENGINE_POWER * Input.get_action_strength("reverse")
	
	# Slow car to a halt if velocity is low
	linear_damp = 1.0 if linear_velocity.length() < 0.5 else 0.0
	
	set_engine_force(_desired_engine_force)
	set_steering(move_toward(steering, _desired_steer, STEER_SPEED * delta))


func jolt_vehicle(amt: float) -> void:
	# TODO: using "global" dir. fix to always same dir
	angular_velocity.z += amt
