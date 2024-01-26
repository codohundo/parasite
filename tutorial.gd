extends CanvasLayer

@onready var ev: GameEvents = get_node("/root/game_events")
@onready var message: Label = get_node("ColorRect/VBox/HBox/Message")
@onready var timer: Timer = get_node("MessageTimer")

var firstPlayeMoved = false

func _ready():
	ev.something_happened.connect(game_changed)
	get_node("MessageTimer").timeout.connect(on_message_timer_end)

func game_changed(evt):
	print("tutorial: got " + evt)
	if evt == "tutorial_basic_movement":
		handle_player_moved()
	elif evt == "tutorial_energy":
		eating_energy()

func eating_energy():
	message.text = "Movement takes energy. Find something to eat!"
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
