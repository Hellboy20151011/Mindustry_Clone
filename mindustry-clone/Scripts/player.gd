extends CharacterBody2D

@export var max_speed: float = 280.0
@export var acceleration: float = 1400.0
@export var friction: float = 900.0

# Optional: Drehgeschwindigkeit, wenn du Richtung Maus rotieren willst
@export var rotate_to_mouse: bool = true

func _physics_process(delta: float) -> void:
	var input_vec := Vector2.ZERO
	input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vec = input_vec.normalized()

	# Beschleunigen, wenn Input da ist
	if input_vec != Vector2.ZERO:
		velocity = velocity.move_toward(input_vec * max_speed, acceleration * delta)
	else:
		# Ausrollen/Abbremsen
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# Optional: Player schaut zur Maus
	if rotate_to_mouse:
		look_at(get_global_mouse_position())
