extends Area2D
#turn into packed scene or a class?, load spec from file

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

#for now rooms should be either 7x7, 7x12, 12x7, or 12x12 (actually 5 or 10, but room for boundary and entrance/exit)
func _ready() -> void:
#func _init(room_size_x: int, room_size_y: int) -> void:
	size_x = 7
	size_y = 7
	build_room()

#TODO test
func can_walk(position: Vector2i, direction: String) -> bool:
	print("current position: " + str(position)) 
	print("direction: " + direction) 
	if position == entrance_pos:
		print("entrance tile")
		if direction == entrance_direction:
			return true
		else:
			return false
	if position == exit_pos:
		print("exit tile")
		if direction == exit_direction:
			return true
		else:
			return false
	var nextTile = get_adjacent_tile(position, direction) 
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


func debugPrintRoom() -> void:
	for y in size_y :
		var row = "[ "
		for x in size_x :
			row += get_tile(x,y).txt()
		row += " ]"
		print(row)


func set_tile(tile: Tile, x: int, y: int) -> void :
	map[y*size_y+x] = tile


func get_tile(x: int, y: int) -> Tile :
	return map[y*size_y+x]


func build_room() -> void:
	var wall_tile = Tile.new_wall_tile()
	var floor_tile = Tile.new_floor_tile()
	var entrance_tile = Tile.new_entrance_tile()
	var exit_tile = Tile.new_exit_tile()

	#row by row, need to refactor this, pull from resource?
	map.append(wall_tile)
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
	
	map.append(entrance_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(exit_tile)
	entrance_direction = "right"
	entrance_pos = Vector2(0,2)
	exit_direction = "right"
	exit_pos = Vector2(6,2)
	
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)

	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	
	debugPrintRoom()
