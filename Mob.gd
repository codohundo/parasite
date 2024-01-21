class_name Mob

#will prevent jumping or walking past, must be delt with if touching
func grabby() -> bool:
	return false

#can share a square with the player
func share() -> bool:
	return false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
