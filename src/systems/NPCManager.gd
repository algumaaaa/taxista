extends Node


# could check all lanes near player (costly?) or group them by ID and check IDs nearby

var registered_vehicles: Array[NPCVehicle] = []
var registered_pedestrians: Array[NPCPedestrian] = []
var registered_lanes: Array[LaneWall] = []
var _registered_lane_ids: Array[int] = []
var registered_sidewalks: Array[SideWalkWall] = []
var _registered_sidewalk_ids: Array[int] = []

const MAX_VEHICLES: int = 15
const MAX_PEDESTRIANS: int = 15
const VEHICLE_INSTANCING_COOLDOWN: float = 3.0
const NPC_VEHICLE = preload("res://src/npc/npc_vehicle/NPCVehicle.tscn")
const NPC_PEDESTRIAN = preload("res://src/npc/npc_pedestrian/NPCPedestrian.tscn")


func register_lane(new_lane: LaneWall) -> int:
	if registered_lanes.has(new_lane):
		registered_lanes.push_back(new_lane)
	# Give it unique ID
	var _rand_id := randi()
	while _rand_id in _registered_lane_ids:
		_rand_id = randi()
	return _rand_id


func register_sidewalk(new_sidewalk: SideWalkWall) -> int:
	if not registered_sidewalks.has(new_sidewalk):
		registered_sidewalks.push_back(new_sidewalk)
	# Give it unique ID
	var _rand_id := randi()
	while _rand_id in _registered_sidewalk_ids:
		_rand_id = randi()
	return _rand_id


# Recursive function for instancing vehicles when needed
func manage_npc_instancing() -> void:
	await get_tree().create_timer(VEHICLE_INSTANCING_COOLDOWN).timeout
	var _needed_vehicles: int = MAX_VEHICLES - registered_vehicles.size()
	var _needed_pedestrians: int = MAX_PEDESTRIANS - registered_pedestrians.size()
	if _needed_vehicles > 0:
		_instance_vehicles()
	if _needed_pedestrians > 0:
		_instance_pedestrians()
	manage_npc_instancing()


func _instance_vehicles() -> void:
	if registered_lanes.is_empty():
		return
	var _needed_vehicles: int = MAX_VEHICLES - registered_vehicles.size()
	if _needed_vehicles <= 0:
		return
	
	for i in _needed_vehicles:
		var _lane = _request_random_lane()
		if not _lane.is_inside_tree():
			continue
		var _new_npc = NPC_VEHICLE.instantiate()
		Global.scene.add_child(_new_npc)
		_new_npc.global_position = _lane.global_position
		_new_npc.global_rotation = _lane.global_rotation
		registered_vehicles.push_back(_new_npc)


func _instance_pedestrians() -> void:
	if registered_sidewalks.is_empty():
		return
	var _needed_pedestrians: int = MAX_PEDESTRIANS - registered_pedestrians.size()
	if _needed_pedestrians <= 0:
		return
	_request_unoccupy_sidewalks()
	
	for i in _needed_pedestrians:
		var _sidewalk = _request_random_sidewalk()
		if not _sidewalk.is_inside_tree():
			continue
		var _new_npc = NPC_PEDESTRIAN.instantiate()
		Global.scene.add_child(_new_npc)
		_new_npc.global_position = _sidewalk.global_position
		_new_npc.global_rotation = _sidewalk.global_rotation
		registered_pedestrians.push_back(_new_npc)


func _request_random_lane() -> LaneWall:
	if registered_lanes.is_empty():
		return LaneWall.new()

	for lane in registered_lanes:
		if not lane.spawner:
			continue
		if lane.occupied:
			continue
		if lane.global_position.distance_to(Global.player.global_position) > 100:
			continue
		if lane.is_visible_to_player():
			continue
		if randi_range(0, 3) < 1:
			lane.occupied = true
			return lane
	
	return LaneWall.new()


func _request_random_sidewalk() -> SideWalkWall:
	if registered_sidewalks.is_empty():
		return SideWalkWall.new()

	for sidewalk in registered_sidewalks:
		if not sidewalk.spawner:
			continue
		if sidewalk.occupied:
			continue
		if sidewalk.global_position.distance_to(Global.player.global_position) > 100:
			continue
		if sidewalk.is_visible_to_player():
			continue
		if randi_range(0, 3) < 1:
			sidewalk.occupied = true
			return sidewalk
	
	return SideWalkWall.new()


func _request_unoccupy_lane(id: int) -> void:
	# Check if any other vehicles are using this lane, if not, unoccupy
	for vehicle in registered_vehicles:
		if vehicle.curr_lane_id == id:
			return
	for lane in registered_lanes:
		if lane.id == id:
			lane.occupied = false


func _request_unoccupy_sidewalks() -> void:
	# Check if unnocupy cooldowns have expired
	for sidewalk in registered_sidewalks:
		if Time.get_ticks_msec() - sidewalk.last_time_occupied < sidewalk.UNNOCUPY_COOLDOWN:
			sidewalk.occupied = false
