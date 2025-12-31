extends CharacterBody2D

signal inventory_changed(key: String, new_value: int)
signal health_changed(current: float, maximum: float)
signal shield_changed(current: float, maximum: float)

# Player Statistics
@export_group("Player Stats")
@export var max_health: float = 100.0
@export var max_shield: float = 50.0
@export var build_speed: float = 1.0  # Multiplier for building actions

@export_group("Movement")
@export var max_speed: float = 280.0
@export var acceleration: float = 1400.0
@export var friction: float = 900.0

# Optional: Drehgeschwindigkeit, wenn du Richtung Maus rotieren willst
@export var rotate_to_mouse: bool = true

# Zoom mit Mausrad
@export var zoom_min: float = 0.5
@export var zoom_max: float = 1.4
@export var zoom_step: float = 0.1
@export var zoom_lerp_speed: float = 10.0

# Mining
@export var enable_mining: bool = true

@onready var cam: Camera2D = $Camera2D
@onready var interact_area: Area2D = $Interact_Area

var target_zoom: float = 0.8

# Current stat values
var current_health: float
var current_shield: float

# Inventar (Startwerte)
var inventory := {
	"stone": 0,
	"wood": 0,
	"coal": 0,
	"iron": 0
}

# Nur diese Ressourcen darf der Spieler direkt abbauen
var player_mineable := {
	"stone": true,
	"wood": true,
	"coal": true
}

# Aktuelles Ziel im Interaktionsradius
var _current_target = null

# Für “harvest_per_second * delta”, aber nur ganze Einheiten buchen
var _fraction_buffer := {} # key -> float

func _ready() -> void:
	target_zoom = cam.zoom.x
	
	# Initialize stats
	current_health = max_health
	current_shield = max_shield
	
	# Emit initial stat values
	health_changed.emit(current_health, max_health)
	shield_changed.emit(current_shield, max_shield)

func _physics_process(delta: float) -> void:
	# --- Bewegung ---
	var input_vec := Vector2.ZERO
	input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vec = input_vec.normalized()

	if input_vec != Vector2.ZERO:
		velocity = velocity.move_toward(input_vec * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# --- Blick zur Maus ---
	if rotate_to_mouse:
		look_at(get_global_mouse_position())

	# --- Zoom (Input) ---
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom = max(zoom_min, target_zoom - zoom_step)
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom = min(zoom_max, target_zoom + zoom_step)

	# --- Zoom (Smooth) ---
	var current_zoom := cam.zoom.x
	var new_zoom := lerpf(current_zoom, target_zoom, zoom_lerp_speed * delta)
	cam.zoom = Vector2(new_zoom, new_zoom)

func _process(delta: float) -> void:
	if not enable_mining:
		return

	_update_target()

	# Mining gedrückt halten
	if Input.is_action_pressed("mine") and _current_target != null:
		_try_mine(_current_target, delta)

func _update_target() -> void:
	_current_target = null

	var areas := interact_area.get_overlapping_areas()
	for a in areas:
		# robust: per Gruppe oder per Methodencheck
		# Empfehlung: ResourceNodes in Gruppe "resource_node" packen.
		if a.is_in_group("resource_node"):
			_current_target = a
			return

		# Fallback: wenn du wirklich eine Klasse ResourceNode verwendest
		# (nur aktiv lassen, wenn dein Script `class_name ResourceNode` hat)
		if a is ResourceNode:
			_current_target = a
			return

func _try_mine(node, delta: float) -> void:
	# key ermitteln
	var key := ""

	# bevorzugt: Methode im ResourceNode
	if node.has_method("get_resource_key"):
		key = node.call("get_resource_key")
	# alternativ: exported variable resource_key/resource_type
	elif "resource_key" in node:
		key = node.resource_key
	elif "resource_type" in node:
		key = str(node.resource_type).to_lower()
	else:
		return

	# darf der Spieler das abbauen?
	if not player_mineable.has(key):
		return

	# harvest pro sekunde ermitteln
	var hps := 0.0
	if "harvest_per_second" in node:
		hps = float(node.harvest_per_second)
	elif "harvest_rate" in node:
		hps = float(node.harvest_rate)
	else:
		# Default (falls du es noch nicht gesetzt hast)
		hps = 2.0

	var gain_float := hps * delta
	_add_resource_fractional(key, gain_float)

func _add_resource_fractional(key: String, amount: float) -> void:
	if not _fraction_buffer.has(key):
		_fraction_buffer[key] = 0.0
	if not inventory.has(key):
		inventory[key] = 0

	_fraction_buffer[key] += amount
	var whole := int(floor(_fraction_buffer[key]))

	if whole > 0:
		_fraction_buffer[key] -= float(whole)
		inventory[key] += whole
		inventory_changed.emit(key, inventory[key])

func get_inventory() -> Dictionary:
	return inventory

# Stat management functions
func take_damage(amount: float) -> void:
	"""Apply damage to shield first, then health"""
	if current_shield > 0:
		var shield_damage = min(amount, current_shield)
		current_shield -= shield_damage
		amount -= shield_damage
		shield_changed.emit(current_shield, max_shield)
	
	if amount > 0 and current_health > 0:
		current_health = max(0, current_health - amount)
		health_changed.emit(current_health, max_health)
		
		if current_health <= 0:
			_on_death()

func heal(amount: float) -> void:
	"""Restore health"""
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func restore_shield(amount: float) -> void:
	"""Restore shield"""
	current_shield = min(max_shield, current_shield + amount)
	shield_changed.emit(current_shield, max_shield)

func get_stats() -> Dictionary:
	"""Return all player stats"""
	return {
		"max_health": max_health,
		"current_health": current_health,
		"max_shield": max_shield,
		"current_shield": current_shield,
		"max_speed": max_speed,
		"build_speed": build_speed
	}

func _on_death() -> void:
	"""Called when player health reaches 0"""
	# Placeholder for death logic
	print("Player died!")
	# Could implement respawn, game over, etc.
