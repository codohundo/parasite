extends CanvasLayer

signal roomChange


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_room1_pressed() -> void:
	print("R1 click emit r1")
	roomChange.emit("room1")


func _on_room2_pressed() -> void:
	print("R2 click emit r2")
	roomChange.emit("room2")
	
	
func _on_room3_pressed() -> void:
	print("R2 click emit r2")
	roomChange.emit("room3")

