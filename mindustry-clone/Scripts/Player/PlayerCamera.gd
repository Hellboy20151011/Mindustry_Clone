# PlayerCamera.gd - Handles player camera and zoom logic
extends Node
class_name PlayerCamera

@export_group("Camera")
@export var rotate_to_mouse: bool = true
@export var zoom_min: float = 0.5
@export var zoom_max: float = 1.4
@export var zoom_step: float = 0.1
@export var zoom_lerp_speed: float = 10.0
@export var initial_zoom: float = 0.8

@onready var cam: Camera2D = null
var _player: Node2D = null
var target_zoom: float = 0.8

func _ready() -> void:
	_player = get_parent() as Node2D
	if _player == null:
		push_error("PlayerCamera must be a child of Node2D")
		return
	
	# Find Camera2D node
	cam = _player.get_node_or_null("Camera2D")
	if cam == null:
		push_error("PlayerCamera requires a Camera2D node as sibling")
		return
	
	target_zoom = initial_zoom

func process_camera(delta: float) -> void:
	if _player == null or cam == null:
		return
	
	# Rotation to mouse
	if rotate_to_mouse:
		_player.look_at(_player.get_global_mouse_position())
	
	# Zoom input
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom = max(zoom_min, target_zoom - zoom_step)
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom = min(zoom_max, target_zoom + zoom_step)
	
	# Smooth zoom
	var current_zoom := cam.zoom.x
	var new_zoom := lerpf(current_zoom, target_zoom, zoom_lerp_speed * delta)
	cam.zoom = Vector2(new_zoom, new_zoom)
