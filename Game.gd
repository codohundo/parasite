extends Node

@onready var hud = get_node("/root/hud")
@onready var camera = $Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.roomChange.connect(handleRoomChange)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vp = get_viewport()
	#print(vp.get_visible_rect().size)

func handleRoomChange(room: String) -> void:
	print("handle room change: " + room)
	match room:
		"room1":
			camera.move(Vector2i(100,100))
		"room2":
			camera.look_at(Vector2i(200,200))
		"room3":
			camera.look_at(Vector2i(300,300))
