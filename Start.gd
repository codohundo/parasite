extends CanvasLayer

var game = preload("res://game.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game)


func _on_quit_pressed() -> void:
	get_tree().queue_delete(game)
	get_tree().quit()
