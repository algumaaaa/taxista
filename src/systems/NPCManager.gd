extends Node


# could check all lanes near player (costly?) or group them by ID and check IDs nearby

var registered_vehicles: Array[NPCVehicle] = []
var registered_lanes: Array[LaneWall] = []
var _registered_ids: Array[int] = []
const MAX_VEHICLES: int = 15
const VEHICLE_INSTANCING_COOLDOWN: float = 3.0
const NPC_VEHICLE = preload("res://src/npc/npc_vehicle/NPCVehicle.tscn")


func register_lane(new_lane: LaneWall) -> int:
	if not registered_lanes.has(new_lane):
		registered_lanes.push_back(new_lane)
	# Give it unique ID
	var _rand_id := randi()
	while _rand_id in _registered_ids:
		_rand_id = randi()
	return _rand_id


# Recursive function for instancing vehicles when needed
func manage_vehicle_instancing() -> void:
	await get_tree().create_timer(VEHICLE_INSTANCING_COOLDOWN).timeout
	var _needed_vehicles: int = MAX_VEHICLES - registered_vehicles.size()
	if _needed_vehicles > 0:
		_instance_vehicles()
	manage_vehicle_instancing()


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

	for lane in registered_lanes:
		if lane.global_position.distance_to(Global.player.global_position) > 100:
			continue
		if lane.occupied:
			continue
		if lane.is_visible_to_player():
			continue
		if randi_range(0, 3) < 1:
			lane.occupied = true
			return lane
	
	return LaneWall.new()


func _request_unoccupy_lane(id: int) -> void:
	# Check if any other vehicles are using this lane, if not, unoccupy
	for vehicle in registered_vehicles:
		if vehicle.curr_lane_id == id:
			return
	for lane in registered_lanes:
		if lane.id == id:
			lane.occupied = false
