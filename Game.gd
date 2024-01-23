extends Node

@onready var hud = get_node("/root/hud")
@onready var camera = $Camera
@onready var map = $TileMap
@onready var player: Player = $Player
@onready var room1 = $Rooms/Room1
@onready var room2 = $Rooms/Room2

@onready var pointer = load("res://Assets/pointer.png")
@onready var target = load("res://Assets/target.png")

signal STATE_CHANGE

enum STATES {NORMAL, CASTING_RANGE}
enum ABILIITIES {NONE, EAT}
var movement_cost = 5

var current_room: Node2D
var current_state: STATES = STATES.NORMAL
var current_ability: ABILIITIES = ABILIITIES.NONE

#todo 
#design first couple of creaters
#design first couple of abilities
#	jump
#design upgrade system?
#	possible upgrades, redusced cost, extra energy, new ablilities (jump, float, pull, push, extinguise)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.roomChange.connect(handle_room_change)
	room1.room_entered.connect(handle_room_change)
	room2.room_entered.connect(handle_room_change)
	player.player_energy_zero.connect(handle_player_dead)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_ARROW)
	current_room = room1
	player.infinite_energy = true
	var startingPos  = player.global_position
	handle_player_moved(startingPos)
	#change room to room 1 to start, then use handle room change to do follow
	current_room.hide_fow()
	print("cp: " + str(camera.position))

func process_input(direction: String, current_position: Vector2i) -> void :
	var new_position: Vector2
	current_room.debug_print_room()
	if player.energy < movement_cost :
		print("too weak")
		return
	print("going " + direction)
	if current_room.can_walk(current_position, direction):
		print("can walk")
		var current_tile_pos = map.get_tile_pos_from_global_pos(current_position)
		print("current position: " + str(current_position))
		print("current global tile pos: " + str(current_tile_pos))
		new_position = player.move_cardinal(direction)#TODO convert to enum
		var new_tile_pos = map.get_tile_pos_from_global_pos(new_position)
		var new_tile: Tile = current_room.get_tile_global(new_tile_pos)
		new_tile.send_signal()
		player.pay_energy(movement_cost)
		print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
		print("new tile global pos: " + str(new_tile_pos))
		handle_player_moved(new_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_position = map.get_tile_pos_from_global_pos(player.global_position)
	var new_position: Vector2
	if current_state == STATES.NORMAL :
		if Input.is_action_just_pressed("left") :
			process_input("left", current_position)
		if Input.is_action_just_pressed("right") :
			process_input("right", current_position)
		if Input.is_action_just_pressed("up") :
			process_input("up", current_position)
		if Input.is_action_just_pressed("down") :
			process_input("down", current_position)
		if Input.is_action_just_pressed("eat") :
			start_eat()
	elif current_state == STATES.CASTING_RANGE :
		if Input.is_action_just_pressed("cancel") :
			print("cancel pressed")
			current_state = STATES.NORMAL
			STATE_CHANGE.emit(STATES.NORMAL)
			Input.set_custom_mouse_cursor(pointer)
		if Input.is_action_just_pressed("target") :
			#TODO this whole thing should be handled in an _input func  I think?
			var pos = map.get_local_mouse_position()
			var tilePos = map.local_to_map(pos)
			print("target clicked at: " + str(tilePos))
			target_selected(tilePos)
			
			current_state = STATES.NORMAL
			STATE_CHANGE.emit(STATES.NORMAL)
			Input.set_custom_mouse_cursor(pointer)

func target_selected(current_global_tile_pos: Vector2i ) -> void: 
	match current_ability :
		ABILIITIES.NONE :
			print("no active ability")
			return
		ABILIITIES.EAT :
			print("find mob")
			var mob = current_room.get_mob_at(current_global_tile_pos)
			if mob != null :
				print( "eating: " + mob.mob_name)
				player.eat(mob)
				current_room.kill_mob_at(current_global_tile_pos)
				map.remove_spite(current_global_tile_pos)



func start_eat():
	current_state = STATES.CASTING_RANGE
	print("eat mode")
	STATE_CHANGE.emit(current_state)
	Input.set_custom_mouse_cursor(target)
	current_ability = ABILIITIES.EAT


#TODO when converting rooms to a proper class and loading from a file, change this from room name to 
#the actual room object
func handle_room_change(room_name: String) -> void:
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
				player.infinite_energy=false
				player.energy = 50
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
	

func handle_player_moved(position: Vector2)  -> void :
	map.handle_player_moved(position)
	var energy_string: String = ""


func handle_player_dead() -> void:
	print("you dead!")
