extends CanvasLayer

@onready var ev: GameEvents = get_node("/root/game_events")
@onready var message: Label = get_node("ColorRect/VBox/HBox/Message")
@onready var timer: Timer = get_node("MessageTimer")

# tutorial events. first value is the handler, second is a marker
# indicating if we've seen this one before
var tutorial_events = {
	"tutorial_basic_movement": [set_generic_message.bind("Use W,A,S,D to move"), true],
	"tutorial_energy": [set_generic_message.bind("Movement takes energy. Find something to eat!"), true],
	"tutorial_eating_energy": [eating_energy, true],
	"tutorial_toxic_floor": [set_generic_message.bind("The  red floor, it burns us, better avoid any unneccesary movement"), true],
	"tutorial_vibrant_floor": [set_generic_message.bind("This floor is soothing and easier to move through"), true],
	"tutorial_eat_up": [set_generic_message.bind("that next room looks dangerous, better eat up while you can"), true],
	"tutorial_hole": [set_generic_message.bind("Pits block your movement, we might learn a way to get past these in the future"), true],
	"tutorial_water": [set_generic_message.bind("This looks like a nice lake, too bad we can't swim... yet"), true],
	"tutorial_better_eat": [set_generic_message.bind("Use the eat ability (click on eat or hit '1') and click on the blue wisp"), true],
	"player_level_up": [set_generic_message.bind("Unlocked the ability to jump over one square, click on jump (or press 2) and then select an open tile exactly 2 squares away in a cardinal directio"), true]
}

var energy_messages = [
	"Mmm, chicken. Wait. Why does it taste like chicken?",
	"Oh, yeah. That's some good energy",
	"Ugh, tofu."
]

func _ready():
	ev.something_happened.connect(game_changed)

func game_changed(evt):
	if evt in tutorial_events and tutorial_events[evt][1]:
		tutorial_events[evt][1] = false
		tutorial_events[evt][0].call()

func set_generic_message(msg: String):
	message.text = msg
	timer.start()
	show()
	
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
	message.text = energy_messages[randi() % (len(energy_messages))]
	tutorial_events["tutorial_eating_energy"][1] = true;
	timer.start()
	show()
	
func handle_player_moved():
	message.text = "Use W,A,S,D to move"
	timer.start()
	show()
	
func on_message_timer_end():
	print("hide tutorial")
	hide()

# resize the color background when the child node does
func _on_v_box_resized():
	print("tutorial: container size" + str(get_node("ColorRect/VBox").size))
	print("tutorial: label size" + str(get_node("ColorRect/VBox/HBox/Message").size))
	get_node("ColorRect").size = get_node("ColorRect/VBox").size + Vector2(20,20)# Replace with function body.
