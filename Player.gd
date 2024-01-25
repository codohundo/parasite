extends CharacterBody2D
class_name Player

signal player_moved 
signal player_energy_zero
signal player_event #TODO tutorial popup here, we've boosted your energy for this room, nobody dies in the first room
signal player_level_up
signal player_energy_update

@onready var anim = $AnimatedSprite2D

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
			move_local_y(-16)
		"down":
			move_local_y(16)
		"left":
			move_local_x(-16)
		"right":
			move_local_x(16)
	return global_position
	#caller has checked it move is legal
	#play squish down animation
	#move
	#if needed add creep
	#play squish up animation

func level_up() -> void:
	level += 1;
	print("level: " + str(level))
	player_level_up.emit(level)

#need methods to play 
	#attack animation
	#jump animation
	#pull animation
	#push animation
	#infect animation
	#eat animation

