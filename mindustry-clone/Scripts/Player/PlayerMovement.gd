# PlayerMovement.gd - Handles player movement logic
extends Node
class_name PlayerMovement

@export_group("Movement")
@export var max_speed: float = 280.0
@export var acceleration: float = 1400.0
@export var friction: float = 900.0

var _player: CharacterBody2D = null

func _ready() -> void:
	_player = get_parent() as CharacterBody2D
	if _player == null:
		push_error("PlayerMovement must be a child of CharacterBody2D")

func process_movement(delta: float) -> void:
	if _player == null:
		return
	
	var input_vec := Vector2.ZERO
	input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vec = input_vec.normalized()

	if input_vec != Vector2.ZERO:
		_player.velocity = _player.velocity.move_toward(input_vec * max_speed, acceleration * delta)
	else:
		_player.velocity = _player.velocity.move_toward(Vector2.ZERO, friction * delta)

	_player.move_and_slide()

func get_max_speed() -> float:
	return max_speed
