extends Control

func _ready() -> void:
	pass

func _on_back_pressed() -> void:
	# Return to main menu
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
