extends Area2D


#room one learn about basic movement
var mobs = []
var map: Array = []
var size_x = 0
var size_y = 0
var empty_tile = Tile.new()
var room_type = Tile.ROOM_TYPES.NORMAL

#for now rooms should be either 7x7, 7x12, 12x7, or 12x12 (actually 5 or 10, but room for boundary and entrance/exit)
func _ready() -> void:
#func _init(room_size_x: int, room_size_y: int) -> void:
	size_x = 7
	size_y = 7
	var wall_tile = Tile.new_wall_tile()
	var floor_tile = Tile.new_floor_tile()

	#row by row, need to refactor this
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
	
	map.append(floor_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(floor_tile)
	
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
	map.append(wall_tile)
	map.append(floor_tile)
	map.append(wall_tile)
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

