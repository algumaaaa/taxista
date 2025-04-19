extends Node


# need to spawn vehicles around player, out of camera view
# need to identify lanes, spawn vehicles facing lanes' forward vector
# could check all lanes near player (costly?) or group them by ID and check IDs nearby

var registered_vehicles: Array[NPCVehicle] = []
var registered_lanes: Array[LaneWall] = []
const MAX_VEHICLES: int = 15
const NPC_VEHICLE = preload("res://src/npc/npc_vehicle/NPCVehicle.tscn")

# needed? this will be spawning vehicles regardless, it should already be aware of all
# func register_vehicle()


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	_instance_vehicles()


func register_lane(new_lane: LaneWall) -> void:
	if not registered_lanes.has(new_lane):
		registered_lanes.push_back(new_lane)


func _instance_vehicles() -> void:
	if registered_lanes.is_empty():
		return
	var _needed_vehicles: int = MAX_VEHICLES - registered_vehicles.size()
	if _needed_vehicles <= 0:
		return
	
	for i in _needed_vehicles:
		var _lane = _request_random_lane()
		if not _lane:
			continue
		var _new_npc = NPC_VEHICLE.instantiate()
		Global.scene.add_child(_new_npc)
		_new_npc.global_position = _lane.global_position
		_new_npc.global_rotation = _lane.global_rotation
		
		registered_vehicles.push_back(_new_npc)


func _request_random_lane() -> LaneWall:
	if registered_lanes.is_empty():
		return LaneWall.new()

	var _used_lanes: Array[LaneWall] = [] # Lanes used in this spawn cycle
	# Need to also check if a lane isn't already occuppied
	for lane in registered_lanes:
		if lane.global_position.distance_to(Global.player.global_position) > 100:
			continue
		if lane.occupied:
			continue
		if randi_range(0, 3) < 1:
			lane.occupied = true
			return lane
	
	return LaneWall.new()


func _request_unoccupy_lane(id: int) -> void:
	# Check if any other vehicles are using this lane, if not, unoccupy
	# check if no other registered car's curr lane id is this one
	for vehicle in registered_vehicles:
		if vehicle.curr_lane_id == id:
			return
	for lane in registered_lanes:
		if lane.id == id:
			lane.occupied = false
