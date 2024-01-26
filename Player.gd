extends CharacterBody2D
class_name Player

signal player_moved 
signal player_energy_zero
signal player_event #TODO tutorial popup here, we've boosted your energy for this room, nobody dies in the first room
signal player_level_up
signal player_energy_update

@onready var anim = $normal
@onready var walk_right = $walk_right
@onready var walk_left = $walk_left
@onready var ding_sound = $ding_sound
@onready var walk_up = $walk_up
@onready var walk_down = $walk_down
var energy = 100
var current_max_energy = 200
var movement_cost = 5
var infinite_energy: bool = false
var level: int = 1
var jump_cost = 15


func _ready() -> void:
	anim.play("pulse")
	player_energy_update.emit(energy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func eat(mob: Object) -> void :
	if level < 2 :
		print("not high enough level")
		return 
	print("Energy: %s/%s" % [str(energy),str(current_max_energy)])
	energy += mob.consumption_energy
	print("Swallow it's soul")
	print("Energy: %s/%s" % [str(energy),str(current_max_energy)])
	player_energy_update.emit(energy)


func set_energy(new_energy: int) -> void :
	energy = new_energy
	player_energy_update.emit(energy)


func pay_energy(cost: int) -> void:
	if infinite_energy && energy < 10 :
		player_event.emit("tutorial_min_energy")
	else :
		energy -= cost
		print("Energy: %s/%s" % [str(energy),str(current_max_energy)])
	if energy <= 0 :
		player_energy_zero.emit()
		
	player_energy_update.emit(energy)


func jump_cardinal(direction: String) -> Vector2:
	match direction:
		"up":
			move_local_y(-32)
		"down":
			move_local_y(32)
		"left":
			move_local_x(-32)
		"right":
			move_local_x(32)
	return global_position

func move_cardinal(direction: String) -> Vector2:
	match direction:
		"up":
			anim.hide()
			move_local_y(-16)
			animate_walking_up()
		"down":
			anim.hide()
			move_local_y(16)
			animate_walking_down()
		"left":
			anim.hide()
			move_local_x(-16)
			animate_walking_left()
		"right":
			anim.hide()
			move_local_x(16)
			animate_walking_right()
			
	return global_position
	#caller has checked it move is legal
	#play squish down animation
	#move
	#if needed add creep
	#play squish up animation


func animate_walking_right() -> void :
	walk_right.show()
	walk_right.animation_finished.connect(hide_walk)
	walk_right.play()


func animate_walking_left() -> void :
	walk_left.show()
	walk_left.animation_finished.connect(hide_walk)
	walk_left.play()


func animate_walking_up() -> void :
	walk_up.show()
	walk_up.animation_finished.connect(hide_walk)
	walk_up.play()


func animate_walking_down() -> void :
	walk_down.show()
	walk_down.animation_finished.connect(hide_walk)
	walk_down.play()


func hide_walk() -> void :
	walk_right.hide()
	walk_left.hide()
	walk_up.hide()
	walk_down.hide()
	anim.show()


func finish_walk() -> void :
	anim.show()


func level_up() -> void:
	level += 1;
	print("level: " + str(level))
	player_level_up.emit(level)
	ding_sound.play()

#need methods to play 
	#attack animation
	#jump animation
	#pull animation
	#push animation
	#infect animation
	#eat animation

