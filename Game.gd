extends Node

@onready var hud = get_node("/root/hud")
@onready var camera = $Camera
@onready var map = $TileMap
@onready var player = $Player
@onready var room1 = $Rooms/Room1
@onready var room2 = $Rooms/Room2

var current_room: Node2D

#todo 
# prevent moving to square that isn't accessable
# room design & mapping
# room detection (enter and exit)
# 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.roomChange.connect(handleRoomChange)
	room1.room_entered.connect(handleRoomChange)
	room2.room_entered.connect(handleRoomChange)
	current_room = room1
	var startingPos  = player.global_position
	handlePlayerMoved(startingPos)
	#change room to room 1 to start, then use handle room change to do follow
	current_room.hide_fow()
	print("cp: " + str(camera.position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_position = map.get_tile_pos_from_global_pos(player.global_position)
	var new_position: Vector2
	#TODO test, there is a bug here
	if Input.is_action_just_pressed("left") :
		current_room.debug_print_room()
		print("going left")
		if current_room.can_walk(current_position, "left"):
			print("can walk")
			new_position = player.move_cardinal("left")#TODO convert to enum
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("right") :
		current_room.debug_print_room()
		print("going right")
		if current_room.can_walk(current_position, "right"): 
			print("can walk")
			new_position = player.move_cardinal("right")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("up") :
		current_room.debug_print_room()
		print("going up")
		if current_room.can_walk(current_position, "up"):
			print("can walk")
			new_position = player.move_cardinal("up")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("down") :
		current_room.debug_print_room()
		print("going down")
		if current_room.can_walk(current_position, "down"):
			print("can walk")
			new_position = player.move_cardinal("down")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)


#TODO when converting rooms to a proper class and loading from a file, change this from room name to 
#the actual room object
func handleRoomChange(room_name: String) -> void:
	print("handle room change: " + room_name)
	if room_name != current_room.room_name:
		match room_name:
			"room1":
				current_room.show_fow()
				current_room = room1
				current_room.hide_fow()
				camera.position = Vector2i(56,88)
			"room2":
				current_room.show_fow()
				current_room = room2
				current_room.hide_fow()
				current_room.debug_print_room()
				camera.position = Vector2i(208,88)
			"room3":
				current_room.show_fow()
				#current_room = room3
				current_room.hide_fow()
				camera.position = Vector2i(168,200)
	#todo on room change
		#shround current room (cover with 2d solid color grey with a bit of alpha) 
		#move player to start of next room
		#move camera to start of next room
			# snap camera to center of room detection area 2d
				# maybe when player enters room, room collider can send event to camera, 
				# packing in event source node, 
				# camera can handle event, and center on source node
				# other rooms can hid themselvs
				# this room can show itself 
				# then that room node can handle custom logig for that room
		#unshroud next room
	

func handlePlayerMoved(position: Vector2)  -> void :
	map.handlePlayerMoved(position)
	
