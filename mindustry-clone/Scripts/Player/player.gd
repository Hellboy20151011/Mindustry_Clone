## Player Controller - Component-based player management
## 
## This is the main player controller that delegates functionality to specialized components.
## It uses a component-based architecture for modularity and maintainability.
## Components handle: movement, camera, inventory, mining, and stats.
extends CharacterBody2D

# Forward signals from components
signal inventory_changed(key: String, new_value: int)
signal health_changed(current: float, maximum: float)
signal shield_changed(current: float, maximum: float)

# Component references
@onready var movement_component: PlayerMovement = $PlayerMovement
@onready var camera_component: PlayerCamera = $PlayerCamera
@onready var inventory_component: PlayerInventory = $PlayerInventory
@onready var mining_component: PlayerMining = $PlayerMining
@onready var stats_component: PlayerStats = $PlayerStats

func _ready() -> void:
# Connect component signals to forward them
if inventory_component:
inventory_component.inventory_changed.connect(_on_inventory_changed)
if stats_component:
stats_component.health_changed.connect(_on_health_changed)
stats_component.shield_changed.connect(_on_shield_changed)

func _physics_process(delta: float) -> void:
if movement_component:
movement_component.process_movement(delta)

if camera_component:
camera_component.process_camera(delta)

func _process(delta: float) -> void:
if mining_component:
mining_component.process_mining(delta)

# Component signal forwarders
func _on_inventory_changed(key: String, new_value: int) -> void:
inventory_changed.emit(key, new_value)

func _on_health_changed(current: float, maximum: float) -> void:
health_changed.emit(current, maximum)

func _on_shield_changed(current: float, maximum: float) -> void:
shield_changed.emit(current, maximum)

# Public API - delegates to components

## Returns the player's current inventory
func get_inventory() -> Dictionary:
if inventory_component:
return inventory_component.get_inventory()
return {}

## Applies damage to the player (shield absorbs first, then health)
## @param amount: The amount of damage to apply
func take_damage(amount: float) -> void:
if stats_component:
stats_component.take_damage(amount)

## Restores player health up to maximum
## @param amount: The amount of health to restore
func heal(amount: float) -> void:
if stats_component:
stats_component.heal(amount)

## Restores player shield up to maximum
## @param amount: The amount of shield to restore
func restore_shield(amount: float) -> void:
if stats_component:
stats_component.restore_shield(amount)

## Returns all player statistics including health, shield, and movement speed
func get_stats() -> Dictionary:
if stats_component and movement_component:
var stats = stats_component.get_stats()
stats["max_speed"] = movement_component.get_max_speed()
return stats
return {}
