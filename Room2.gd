extends Area2D
#turn into packed scene or a class?, load spec from file

signal room_entered

#room one learn about basic movement
var mobs = []
var map: Array = []
var size_x = 0
var size_y = 0
var empty_tile = Tile.new()
var room_type = Tile.ROOM_TYPES.NORMAL
var exit_pos : Vector2i
var exit_direction : String
var entrance_pos : Vector2i
var entrance_direction : String
var room_name = "room2"
var room_origin = Vector2i(7,0)

@onready var fow: ColorRect = $FOW

#for now rooms should be either 7x7, 7x12, 12x7, or 12x12 (actually 5 or 10, but room for boundary and entrance/exit)
func _ready() -> void:
#func _init(room_size_x: int, room_size_y: int) -> void:
	size_x = 12
	size_y = 7
	build_room()

#takes position in global tile space
func can_walk(position: Vector2i, direction: String) -> bool:
	print("current global tile position: " + str(position)) 
	var local_tile_pos = position-room_origin
	print("current room tile position: " + str(local_tile_pos)) 
	print("direction: " + direction) 
	if local_tile_pos == entrance_pos:
		print("entrance tile")
		if direction == entrance_direction:
			return true
		else:
			return false
	if local_tile_pos == exit_pos:
		print("exit tile")
		if direction == exit_direction:
			return true
		else:
			return false
	var nextTile = get_adjacent_tile(local_tile_pos, direction) 
	print("next tile type: " + nextTile.txt())
	return nextTile.can_walk()
#TODO do same with can_jump


func get_adjacent_tile(position: Vector2i, direction: String) -> Tile:
	#do I need to convert from map xy to room xy? how? hardcode where start tile is? hardcode where top left corner is
	print("get_adjacent_tile position: " + str(position) )
	if direction == "up": #TODO need to enum this
		position.y += -1
	if direction == "down":
		position.y += +1
	if direction == "left":
		position.x += -1
	if direction == "right":
		position.x += +1
	print("getting tile at position: " + str(position))
	return get_tile(position.x,position.y) #TODO change to vector 


func debug_print_room() -> void:
	for y in size_y :
		var row = "[ "
		for x in size_x :
			row += get_tile(x,y).txt()
		row += " ]"
		print(row)

#coords local to current room
func set_tile(tile: Tile, x: int, y: int) -> void :
	map[y*size_y+x] = tile


#global tile map coords
func get_tile_global(global_pos: Vector2i) -> Tile:
	var local_pos = global_pos - room_origin
	return get_tile(local_pos.x, local_pos.y)


func get_tile(x: int, y: int) -> Tile :
	return map[y*size_x+x]


func get_mob_at(global_pos: Vector2i) -> Object:
	var target_tile = get_tile_global(global_pos)
	return target_tile.mob


func kill_mob_at(global_pos: Vector2i):
	var target_tile = get_tile_global(global_pos)
	target_tile.mob = null
	#TODO emit killed event, catch somewhere and show an animation


func hide_fow() -> void:
	fow.color.a = 0


func show_fow() -> void:
	fow.color.a = 65


func build_room() -> void:
	var wall_tile = Tile.new_wall_tile()
	var floor_tile = Tile.new_floor_tile()
	var entrance_tile = Tile.new_entrance_tile()
	var pit_tile = Tile.new_pit_tile()
	var exit_tile = Tile.new_exit_tile()
	var mob = ParasiteMob.new()
	mob.mob_name = "Spectral Flame"
	mob.grabby = false
	mob.consumption_energy = 75
	mob.share = false
	mobs.append(mob)
	var mob_tile = Tile.new_floor_tile()
	mob_tile.mob = mob
	var mob_tile2 = Tile.new_floor_tile()
	mob_tile2.mob = mob
	var mob_tile3 = Tile.new_floor_tile()
	mob_tile3.mob = mob
	var event_tile = Tile.new_floor_tile()
	event_tile.event = "tutorial_better_eat"
	var event_tile2 = Tile.new_floor_tile()
	event_tile2.event = "tutorial_hole"
	var event_tile3 = Tile.new_floor_tile()
	event_tile3.event = "tutorial_eat_up"
	#row by row, need to refactor this, pull from resource?
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(mob_tile)
	map.append(event_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	
	map.append(entrance_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(event_tile2)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	entrance_direction = "right"
	entrance_pos = Vector2(0,2)
	
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(pit_tile)
	map.append(wall_tile)
	map.append(mob_tile2)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)

	map.append(wall_tile)
	map.append(mob_tile3)
	map.append(event_tile3)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(exit_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	exit_direction = "down"
	exit_pos = Vector2(0,2)
	
	debug_print_room()


func _on_body_entered(body: Node2D) -> void:
	print("body entered room 2")
	room_entered.emit(room_name)
