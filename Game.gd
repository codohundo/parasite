extends Node

@onready var hud = get_node("/root/hud")
@onready var camera = $Camera
@onready var map = $TileMap
@onready var player = $Player
@onready var room1 = $Rooms/Room1

#todo 
# prevent moving to square that isn't accessable
# room design & mapping
# room detection (enter and exit)
# 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.roomChange.connect(handleRoomChange)
	var startingPos  = player.global_position
	handlePlayerMoved(startingPos)
	#change room to room 1 to start, then use handle room change to do follow
	var room1Fow: ColorRect = get_node("Rooms/Room1/FOW")
	room1Fow.color.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_position = map.get_tile_pos_from_global_pos(player.global_position)
	var new_position: Vector2
	#TODO test, there is a bug here
	if Input.is_action_just_pressed("left") :
		print("going left")
		if room1.can_walk(current_position, "left"):
			print("can walk")
			new_position = player.move_cardinal("left")#TODO convert to enum
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("right") :
		print("going right")
		if room1.can_walk(current_position, "right"): 
			print("can walk")
			new_position = player.move_cardinal("right")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("up") :
		print("going up")
		if room1.can_walk(current_position, "up"):
			print("can walk")
			new_position = player.move_cardinal("up")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
	if Input.is_action_just_pressed("down") :
		print("going down")
		if room1.can_walk(current_position, "down"):
			print("can walk")
			new_position = player.move_cardinal("down")
			print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
			handlePlayerMoved(new_position)
		

func handleRoomChange(room: String) -> void:
	print("handle room change: " + room)
	match room:
		"room1":
			camera.position = Vector2i(100,100)
		"room2":
			camera.position = Vector2i(200,200)
		"room3":
			camera.position = Vector2i(300,300)
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
	
