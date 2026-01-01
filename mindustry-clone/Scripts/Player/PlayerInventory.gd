# PlayerInventory.gd - Handles player inventory management
extends Node
class_name PlayerInventory

signal inventory_changed(key: String, new_value: int)

# Inventar (Startwerte)
var inventory := {
	"stone": 0,
	"wood": 0,
	"coal": 0,
	"iron": 0
}

# Für "harvest_per_second * delta", aber nur ganze Einheiten buchen
var _fraction_buffer := {} # key -> float

func add_resource_fractional(key: String, amount: float) -> void:
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

func add_resource(key: String, amount: int) -> void:
	if not inventory.has(key):
		inventory[key] = 0
	inventory[key] += amount
	inventory_changed.emit(key, inventory[key])

func remove_resource(key: String, amount: int) -> bool:
	if not inventory.has(key) or inventory[key] < amount:
		return false
	inventory[key] -= amount
	inventory_changed.emit(key, inventory[key])
	return true

func get_resource_count(key: String) -> int:
	return inventory.get(key, 0)

func get_inventory() -> Dictionary:
	return inventory
