extends Control

func _ready() -> void:
	pass

func _on_test_map_pressed() -> void:
	# Start the test map
	get_tree().change_scene_to_file("res://Maps/test_map.tscn")

func _on_back_pressed() -> void:
	# Return to main menu
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
