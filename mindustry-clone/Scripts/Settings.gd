extends Control

@onready var back_button: Button = %BackButton
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var volume_slider: HSlider = %VolumeSlider
@onready var volume_label: Label = %VolumeLabel

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	# Initialize settings
	_load_settings()

func _load_settings() -> void:
	# Load current window mode
	fullscreen_check.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Load volume (default to 100%)
	volume_slider.value = 100.0
	volume_label.text = "Lautstärke: %d%%" % int(volume_slider.value)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_volume_changed(value: float) -> void:
	volume_label.text = "Lautstärke: %d%%" % int(value)
	# TODO: Apply volume to audio bus when audio is implemented
	# AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
