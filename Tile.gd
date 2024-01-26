extends Node
class_name Tile
signal tile_event

@onready var ev: GameEvents = get_node("/root/game_events")
const Enums = preload("res://Enums.gd")

enum ROOM_TYPES {NORMAL, VIBRANT, TOXIC, SUPRESSIVE}
enum WALL_TYPES {NONE, WALL, PIT, WATER, ACID}

var empty: bool = true

var room_type = ROOM_TYPES.NORMAL 
var wall_type = WALL_TYPES.NONE
var mob
#var objects = []
var entrance : bool
var exit : bool
var event : String = ""

func can_walk() -> bool:
	assert(!empty, "attempting to use empty tile")
		
	if wall_type == WALL_TYPES.ACID:
		return false
	if wall_type == WALL_TYPES.WATER:
		return false
	if wall_type == WALL_TYPES.PIT:
		return false
	if wall_type == WALL_TYPES.WALL:
		return false
	if mob != null and !mob.share:
		return false
	return true

func txt() -> String :
	if entrance :
		return " I "
	if exit :
		return " O "
	if wall_type == WALL_TYPES.WALL:
		return " W ";
	if wall_type == WALL_TYPES.ACID:
		return " A ";
	if wall_type == WALL_TYPES.PIT:
		return " P ";
	if wall_type == WALL_TYPES.WATER:
		return " O ";
	
	if mob != null : 
		return " m "
	
	if room_type == ROOM_TYPES.VIBRANT:
		return " + "
	if room_type == ROOM_TYPES.TOXIC:
		return " - "
	if room_type == ROOM_TYPES.SUPRESSIVE:
		return " v "
	
	return " . "
	
func can_jump() -> bool:
	assert(!empty, "attempting to use empty tile")
	if wall_type == WALL_TYPES.WALL:
		return false
	if mob != null and mob.grabby:
		return false
	return true


func send_signal() -> void:
	if event != "" :
		print("seinding signal: " + event)
		ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, event)
		tile_event.emit(event)
	

static func new_floor_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.NONE
	tile.empty = false
	return tile


static func new_wall_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.WALL
	tile.empty = false
	return tile


static func new_entrance_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.empty = false
	tile.entrance = true
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.NONE
	return tile


static func new_exit_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.empty = false
	tile.exit = true
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.NONE
	return tile


static func new_pit_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.PIT
	tile.empty = false
	return tile

static func new_water_tile(room_type: ROOM_TYPES = ROOM_TYPES.NORMAL) -> Tile:
	var tile = Tile.new()
	tile.room_type = room_type
	tile.wall_type = Tile.WALL_TYPES.WATER
	tile.empty = false
	return tile
