extends Node

@onready var hud = get_node("/root/hud")
@onready var camera = $Camera
@onready var map = $TileMap
@onready var ev: GameEvents = get_node("/root/game_events")
@onready var player = $Player
@onready var room1 = $Rooms/Room1
@onready var room2 = $Rooms/Room2
@onready var room3 = $Rooms/Room3
@onready var room4 = $Rooms/Room4

@onready var pointer = load("res://Assets/pointer.png")
@onready var target = load("res://Assets/target.png")

@onready var walk_sound = $walk_sound
@onready var eat_sound = $eat_sound
@onready var jump_sound = $jump_sound
@onready var die_sound = $wilhelm_sound

signal state_change
signal game_event
signal game_over_event

const Enums = preload("res://Enums.gd")
const ABILITIES = Enums.ABILITIES
enum STATES {NORMAL, CASTING_RANGE}
var movement_cost = 5 #move to tile?

var current_room: Node2D
var current_state: STATES = STATES.NORMAL
var current_ability: ABILITIES = ABILITIES.NONE

var timer = null 

#TODO for mvp
#design 2nd creater
#design attack
#design upgrade system?
#	possible upgrades, redusced cost, extra energy, new ablilities (jump, float, pull, push, extinguise)
#refactor rooms to be dynamically loaded
#input mapping
#controller support

func _ready() -> void:
	randomize()  # init random seed
	hud.roomChange.connect(handle_room_change)
	room1.room_entered.connect(handle_room_change)
	room2.room_entered.connect(handle_room_change)
	room3.room_entered.connect(handle_room_change)
	room4.room_entered.connect(handle_room_change)
	player.player_energy_zero.connect(handle_player_dead)
	#game_event.connect(ev.handle_event)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_ARROW)
	current_room = room1
	player.infinite_energy = true
	var startingPos  = player.global_position
	handle_player_moved(startingPos)
	current_room.hide_fow()
	movement_cost = current_room.movement_cost
	print("cp: " + str(camera.position))
	print("event: tutorial_basic_movement")
	#game_event.emit("tutorial_basic_movement")
	ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, "tutorial_basic_movement")
	game_over_event.connect(ev.handle_event.bind(Enums.EVENT_CATEGORY.GAME, "game_over"))
	player.player_energy_update.connect(func(e): ev.handle_event(Enums.EVENT_CATEGORY.ENERGY, e))
	ev.something_happened.connect(handle_events)
	player.player_level_up.connect(handle_player_level)

func handle_events(category, evt):
	match category:
		Enums.EVENT_CATEGORY.ABILITY:
			_on_hud_ability_selected(evt)
		Enums.EVENT_CATEGORY.GAME:
			if evt == "restart":
				#restart()
				pass
		

func process_input(direction: String, current_position: Vector2i) -> void :
	var new_position: Vector2
	current_room.debug_print_room()
	if player.energy < movement_cost :
		print("too weak")
		game_over_event.emit()
		die_sound.play()
		return
	print("going " + direction)
	if current_room.can_walk(current_position, direction):
		print("can walk")
		var current_tile_pos = map.get_tile_pos_from_global_pos(current_position)
		print("current position: " + str(current_position))
		print("current global tile pos: " + str(current_tile_pos))
		new_position = player.move_cardinal(direction)#TODO convert to enum
		#TODO new tile pos doesn't work if changing rooms, need to change room first
		#then getnew tile pos
		player.pay_energy(movement_cost)
		var new_tile_pos = map.get_tile_pos_from_global_pos(new_position)
		var new_tile: Tile = current_room.get_tile_global(new_tile_pos)
		if new_tile != null :
			new_tile.send_signal()
		
		print("new position: " + str(map.get_tile_pos_from_global_pos(new_position)))
		print("new tile global pos: " + str(new_tile_pos))
		handle_player_moved(new_position)


func _process(delta: float) -> void:
	#TODO this whole thing should be handled in an _input func  I think?
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
			#check level
			start_eat()
		if Input.is_action_just_pressed("jump") :
			if player.level < 3 :
				print("to low level")
				return
			if player.energy < player.jump_cost :
				print("energy to low")
				return 
			#check energy
			start_jump()
	elif current_state == STATES.CASTING_RANGE :
		if Input.is_action_just_pressed("cancel") :
			print("cancel pressed")
			current_state = STATES.NORMAL
			state_change.emit(STATES.NORMAL)
			Input.set_custom_mouse_cursor(pointer)
		if Input.is_action_just_pressed("target") :
			var pos = map.get_local_mouse_position()
			var tilePos = map.local_to_map(pos)
			print("target clicked at: " + str(tilePos))
			target_selected(tilePos)
			current_state = STATES.NORMAL
			state_change.emit(STATES.NORMAL)
			Input.set_custom_mouse_cursor(pointer)
			hud.set_ability_available(current_ability)


func target_selected(current_global_tile_pos: Vector2i ) -> void: 
	match current_ability :
		ABILITIES.NONE :
			print("no active ability")
			return
		ABILITIES.EAT :
			print("find mob")
			var mob = current_room.get_mob_at(current_global_tile_pos)
			if mob != null && check_eat_range(current_global_tile_pos,map.local_to_map(player.global_position)):
				print( "eating: " + mob.mob_name)
				player.eat(mob)
				game_event.emit("tutorial_eating_energy")
				ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, "tutorial_eating_energy")
				#game_event.emit("score_eat")
				ev.something_happened.emit(Enums.EVENT_CATEGORY.SCORE, "score_eat")
				current_room.kill_mob_at(current_global_tile_pos)
				eat_sound.play()
				map.remove_spite(current_global_tile_pos)
		ABILITIES.JUMP :
			print("find square to land in")
			#click was 2 squares away in a cardnal direction
			var player_pos_global_tile = map.local_to_map(player.global_position)
			var x_dist = abs(current_global_tile_pos.x -player_pos_global_tile.x)
			var y_dist = abs(current_global_tile_pos.y -player_pos_global_tile.y)
			if !((x_dist == 2 && y_dist == 0) || (x_dist == 0 && y_dist == 2)) :
				print("no valid target: x_dist " + str(x_dist) + " y_dist: " + str(y_dist))
				return
			#get target tile and jumped over tile
			var landing_tile = current_room.get_tile_global(current_global_tile_pos)
			if landing_tile == null :
				print("can't jump out of room")
				return
			var skipped_tile_pos = (current_global_tile_pos - player_pos_global_tile) / 2 + player_pos_global_tile
			print("landing tile: " + str(current_global_tile_pos))
			if !landing_tile.can_walk() :
				print("can't land")
				return
			print("skipped tile: " + str(skipped_tile_pos))
			var skipped_tile = current_room.get_tile_global(skipped_tile_pos)
			if !skipped_tile.can_jump() :
				print("can't jump")
				return
			jump_sound.play()
			OS.delay_msec(400)
			if(abs(current_global_tile_pos.x -player_pos_global_tile.x) > 0 ):
				if(current_global_tile_pos.x > player_pos_global_tile.x):
					player.jump_cardinal("right")
				else:
					player.jump_cardinal("left")
			elif (current_global_tile_pos.y > player_pos_global_tile.y):
					player.jump_cardinal("down")
			else:
				player.jump_cardinal("up")
			
			player.pay_energy(player.jump_cost) #refactor to encapsulate
			handle_player_moved_tile_pos(current_global_tile_pos)
			landing_tile.send_signal()


func check_eat_range(pos1: Vector2, pos2: Vector2, padding: float = 0.5)->bool:
	print("distance from: " + str(pos1) + " to: " + str(pos2))
	print(pos1.distance_to(pos2))
	return int(pos1.distance_to(pos2)+padding) < 2


func start_eat()->void:
	current_state = STATES.CASTING_RANGE
	print("eat mode")
	state_change.emit(current_state)
	Input.set_custom_mouse_cursor(target)
	current_ability = ABILITIES.EAT


func start_jump()->void:
	current_state = STATES.CASTING_RANGE
	print("eat mode")
	state_change.emit(current_state)
	Input.set_custom_mouse_cursor(target)
	current_ability = ABILITIES.JUMP


#TODO when converting rooms to a proper class and loading from a file, change this from room name to 
#the actual room object
func handle_room_change(room_name: String) -> void:
	print("handle room change: " + room_name)
	if room_name != current_room.room_name:
		match room_name:
			"room1":
				current_room.show_fow()
				current_room = room1
				movement_cost = current_room.movement_cost
				current_room.hide_fow()
				camera.position = Vector2i(56,88)
				hud.set_ability_unavailable(ABILITIES.JUMP)
				hud.set_ability_unavailable(ABILITIES.EAT)
		
			"room2":
				current_room.show_fow()
				current_room = room2
				movement_cost = current_room.movement_cost
				current_room.hide_fow()
				current_room.debug_print_room()
				camera.position = Vector2i(208,88)
				player.infinite_energy=false
				player.set_energy(50)
				ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, "tutorial_energy")
				game_event.emit("tutorial_energy") # let player know if they run out energy now, they die, bumping to 50
				player.level_up() # gain eat
				hud.set_ability_available(ABILITIES.EAT)
			"room3":
				current_room.show_fow()
				current_room = room3
				movement_cost = current_room.movement_cost
				current_room.hide_fow()
				camera.position = Vector2i(168,200)
				ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, "tutorial_toxic_floor")
				game_event.emit("tutorial_toxic_floor")
			"room4":
				player.level_up() # gain jumnp
				print("handle_room_change room 4 started")
				current_room.show_fow()
				current_room = room4
				movement_cost = current_room.movement_cost
				current_room.hide_fow()
				camera.position = Vector2i(320,250)
				ev.something_happened.emit(Enums.EVENT_CATEGORY.TUTORIAL, "tutorial_vibrant_floor")
				game_event.emit("tutorial_vibrant_floor")
				hud.set_ability_available(ABILITIES.EAT)
				print("handle_room_change room 4 finished")


func handle_player_level(level: int) -> void :
	print("setting player level")
	hud.set_player_level(level)


func handle_player_moved(position: Vector2)  -> void :
	map.handle_player_moved(position)
	walk_sound.play()
	var energy_string: String = ""


func handle_player_moved_tile_pos(position: Vector2)  -> void :
	map.handle_player_moved_tile_pos(position)


func handle_player_dead() -> void:
	print("you dead!")


func _on_hud_ability_selected(ability_selected: ABILITIES):
	if ability_selected == ABILITIES.EAT:
		start_eat()
	elif ability_selected == ABILITIES.JUMP:
		start_jump()
