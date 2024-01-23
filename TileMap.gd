extends TileMap

var object_layer = 2
var mob_layer = 3
var creep_source = 0
var terrain_set = 0
var creep_terrain = 1

var creep_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vp = get_viewport()
	var pos = get_local_mouse_position()
	var tilePos = local_to_map(pos)

	var parasite = Vector2i(0,1)
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) :
		#print("mb")
		#print(tilePos)

func handle_player_moved(position: Vector2) -> void:
	print("pm")
	print(position)
	var tilePos = local_to_map(to_local(position))
	print("tp")
	print(tilePos)
	#set_cell(object_layer, tilePos, creep_source, Vector2i(0,7))
	creep_tiles.append(tilePos)
	set_cells_terrain_connect(object_layer, creep_tiles, terrain_set, creep_terrain )

func remove_spite(position: Vector2)->void:
	erase_cell(mob_layer, position)
	
func get_tile_pos_from_global_pos(position: Vector2) -> Vector2:
	return local_to_map(to_local(position))
