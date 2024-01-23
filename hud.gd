extends CanvasLayer

signal roomChange
signal ability_selected

enum Abilities{JUMP, EAT}

var ability_buttons = {}

func set_ability_available(ability: Abilities) -> void:
	var button = ability_buttons[ability]
	button.disabled = false
	
func set_ability_unavailble(ability: Abilities) -> void:
	var button = ability_buttons[ability]
	button.disabled = true
	
func set_energy(energy: int) -> void:
	$TopBarHBoxContainer/EnergyVBox/EnergyProgressBar.value = energy
	
func set_score(score: int) -> void:
	$TopBarHBoxContainer/ScoreVBox2/Score.value = score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_buttons[Abilities.JUMP] = $TopBarHBoxContainer/AbilitiesContainer/AbilitiesContainer/JumpButton
	ability_buttons[Abilities.EAT] = $TopBarHBoxContainer/AbilitiesContainer/AbilitiesContainer/EatButton

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

func _on_jump_button_pressed():
	ability_selected.emit(Abilities.JUMP)
	var button = ability_buttons[Abilities.JUMP]
	button.disabled = true
	
func _on_eat_button_pressed():
	ability_selected.emit(Abilities.EAT)
	var button = ability_buttons[Abilities.EAT]
	button.disabled = true
	
