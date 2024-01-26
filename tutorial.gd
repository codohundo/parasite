extends CanvasLayer

@onready var ev: GameEvents = get_node("/root/game_events")
@onready var message: Label = get_node("ColorRect/VBox/HBox/Message")
@onready var timer: Timer = get_node("MessageTimer")

var firstPlayeMoved = false
var first_energy = true

func _ready():
	ev.something_happened.connect(game_changed)
	get_node("MessageTimer").timeout.connect(on_message_timer_end)

func game_changed(evt):
	print("tutorial: got " + evt)
	if evt == "tutorial_basic_movement":
		handle_player_moved()
	elif evt == "tutorial_energy":
		energy()
	elif evt == "tutorial_eating_energy":
		eating_energy()
	elif evt == "tutorial_toxic_floor":
		toxic_floor()
	elif evt == "tutorial_toxic_floor":
		vibrant_floor()

func vibrant_floor():
	message.text = "Easy going. this floor takes less energy to move"
	timer.start()
	show()
	
func toxic_floor():
	message.text = "Hard going. This floor takes more energy to move"
	timer.start()
	show()
	
func energy():
	message.text = "Movement takes energy. Find something to eat!"
	timer.start()
	show()

func eating_energy():
	if first_energy:
		message.text = "Mmm, chicken. Wait. Why does it taste like chicken?"
		first_energy = false
	else:
		message.text = "Oh, yeah. That's some good energy"
	timer.start()
	show()
	
func handle_player_moved():
	message.text = "Use W,A,S,D to move"
	timer.start()
	show()
	
func on_message_timer_end():
	print("hide tutorial")
	hide()


func _on_v_box_resized():
	get_node("ColorRect").size = get_node("ColorRect/VBox").size + Vector2(20,20)# Replace with function body.
