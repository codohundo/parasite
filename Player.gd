extends CharacterBody2D


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left") :
		move_local_x(-16)
	if Input.is_action_just_pressed("right") :
		move_local_x(16)
	if Input.is_action_just_pressed("up") :
		move_local_y(-16)
	if Input.is_action_just_pressed("down") :
		move_local_y(16)
		
