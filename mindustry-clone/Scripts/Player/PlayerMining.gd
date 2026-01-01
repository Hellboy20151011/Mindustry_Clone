# PlayerMining.gd - Handles resource mining logic
extends Node
class_name PlayerMining

@export var enable_mining: bool = true

@onready var interact_area: Area2D = null

# Nur diese Ressourcen darf der Spieler direkt abbauen
var player_mineable := {
	"stone": true,
	"wood": true,
	"coal": true
}

# Aktuelles Ziel im Interaktionsradius
var _current_target = null
var _player_inventory: PlayerInventory = null

func _ready() -> void:
	var player = get_parent()
	if player == null:
		push_error("PlayerMining must be a child of player node")
		return
	
	# Find Interact_Area
	interact_area = player.get_node_or_null("Interact_Area")
	if interact_area == null:
		push_error("PlayerMining requires an Interact_Area node")
		return
	
	# Find inventory component
	_player_inventory = player.get_node_or_null("PlayerInventory")
	if _player_inventory == null:
		push_error("PlayerMining requires a PlayerInventory component")

func process_mining(delta: float) -> void:
	if not enable_mining or _player_inventory == null:
		return

	_update_target()

	# Mining gedrückt halten
	if Input.is_action_pressed("mine") and _current_target != null:
		_try_mine(_current_target, delta)

func _update_target() -> void:
	_current_target = null

	if interact_area == null:
		return

	var areas := interact_area.get_overlapping_areas()
	for a in areas:
		# robust: per Gruppe oder per Methodencheck
		if a.is_in_group("resource_node"):
			_current_target = a
			return

		# Fallback: wenn du wirklich eine Klasse ResourceNode verwendest
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
	_player_inventory.add_resource_fractional(key, gain_float)
