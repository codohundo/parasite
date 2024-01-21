extends CharacterBody2D

signal playerMoved 

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("pulse")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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


#need methods to play 
	#attack animation
	#jump animation
	#pull animation
	#push animation
	#infect animation
	#eat animation

