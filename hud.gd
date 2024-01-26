extends CanvasLayer

signal roomChange
signal ability_selected

const Enums = preload("res://Enums.gd")
const ABILITIES = Enums.ABILITIES

var ability_buttons = {}

var player_level: int = 1

var player_score: int = 0:
	set(new_score):
		player_score = new_score
		set_score(player_score)
	get:
		return player_score

func set_ability_available(ability: ABILITIES) -> void:
	if ability in ability_buttons:
		var button = ability_buttons[ability]
		button.disabled = false


func set_ability_unavailable(ability: ABILITIES) -> void:
	if ability in ability_buttons:
		var button = ability_buttons[ability]
		button.disabled = true

func set_player_level(level: int) -> void :
	player_level = level
	if player_level >= 2 :
		ability_buttons[ABILITIES.EAT].disabled = false
	if player_level >= 3 :
		ability_buttons[ABILITIES.JUMP].disabled = false


func set_energy(energy: int) -> void:
	$TopBarHBoxContainer/EnergyVBox/HBoxContainer/EnergyProgressBar.value = energy


func set_score(score: int) -> void:
	$TopBarHBoxContainer/ScoreVBox2/Score.text = str(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_buttons[ABILITIES.JUMP] = $ColorRect/VBoxContainer/AbilitiesContainer/JumpButton
	ability_buttons[ABILITIES.EAT] = $ColorRect/VBoxContainer/AbilitiesContainer/EatButton
	ability_buttons[ABILITIES.JUMP].disabled = true
	ability_buttons[ABILITIES.EAT].disabled = true
	game_events.something_happened.connect(handle_game_events)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jump_button_pressed():
	
	ability_selected.emit(ABILITIES.JUMP)
	var button = ability_buttons[ABILITIES.JUMP]
	button.disabled = true


func _on_eat_button_pressed():
	ability_selected.emit(ABILITIES.EAT)
	var button = ability_buttons[ABILITIES.EAT]
	button.disabled = true


func game_over() -> void :
	$GameOver.visible = true;


func handle_quit_button() -> void:
	print("QUIT")
	get_tree().quit()

func handle_game_events(evt) -> void:
	if evt == "score_new_creep":
		player_score += 2
	if evt == "score_new_creep_jump":
		player_score += 4
	if evt == "score_eat":
		player_score += 8
	
