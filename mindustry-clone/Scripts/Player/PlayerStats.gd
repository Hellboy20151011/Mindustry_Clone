# PlayerStats.gd - Handles player health, shield, and other stats
extends Node
class_name PlayerStats

signal health_changed(current: float, maximum: float)
signal shield_changed(current: float, maximum: float)

@export_group("Player Stats")
@export var max_health: float = 100.0
@export var max_shield: float = 50.0
@export var build_speed: float = 1.0  # Multiplier for building actions

# Current stat values
var current_health: float = 0.0
var current_shield: float = 0.0

func _ready() -> void:
	# Initialize stats
	current_health = max_health
	current_shield = max_shield
	
	# Emit initial stat values
	health_changed.emit(current_health, max_health)
	shield_changed.emit(current_shield, max_shield)

## Apply damage to shield first, then health
func take_damage(amount: float) -> void:
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

## Restore health
func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

## Restore shield
func restore_shield(amount: float) -> void:
	current_shield = min(max_shield, current_shield + amount)
	shield_changed.emit(current_shield, max_shield)

## Return all player stats
func get_stats() -> Dictionary:
	return {
		"max_health": max_health,
		"current_health": current_health,
		"max_shield": max_shield,
		"current_shield": current_shield,
		"build_speed": build_speed
	}

## Called when player health reaches 0
func _on_death() -> void:
	# Placeholder for death logic
	print("Player died!")
	# Could implement respawn, game over, etc.
