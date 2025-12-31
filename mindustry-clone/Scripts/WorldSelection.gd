extends Control

@onready var back_button: Button = %BackButton
@onready var world_list: VBoxContainer = %WorldList

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_populate_worlds()

func _populate_worlds() -> void:
	# Create world selection buttons
	var worlds = ["Neue Welt", "Test Welt", "Survival Welt"]
	
	for world_name in worlds:
		var button = Button.new()
		button.text = world_name
		button.custom_minimum_size = Vector2(400, 60)
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(_on_world_selected.bind(world_name))
		world_list.add_child(button)

func _on_world_selected(world_name: String) -> void:
	# TODO: Implement world-specific loading logic
	# For now, all world buttons load the same test_map scene
	# Future implementation could save/load different world states
	get_tree().change_scene_to_file("res://Maps/test_map.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
