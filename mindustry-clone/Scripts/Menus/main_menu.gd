extends Control

func _ready() -> void:
	pass

func _on_start_game_pressed() -> void:
	# Navigate to world selection menu
	get_tree().change_scene_to_file("res://Scenes/WorldSelection.tscn")

func _on_settings_pressed() -> void:
	# Navigate to settings menu
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_quit_pressed() -> void:
	# Quit the game
	get_tree().quit()
