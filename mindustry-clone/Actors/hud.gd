extends CanvasLayer

@export var player_path: NodePath

@onready var stone_label: Label = %StoneLabel
@onready var wood_label: Label = %WoodLabel
@onready var coal_label: Label = %CoalLabel
@onready var iron_label: Label = %IronLabel

var _player: Node = null

func _ready() -> void:
	if player_path != NodePath():
		_player = get_node(player_path)
	else:
		# Fallback: sucht Player in Gruppe "player"
		_player = get_tree().get_first_node_in_group("player")

	if _player == null:
		push_warning("HUD: Player not found (player_path or group 'player').")
		return

	# Initial anzeigen
	if _player.has_method("get_inventory"):
		_refresh_all(_player.call("get_inventory"))
	else:
		# Falls du get_inventory nicht ergänzt: direkt auf inventory zugreifen, wenn vorhanden
		if "inventory" in _player:
			_refresh_all(_player.inventory)

	# Live-Updates
	if _player.has_signal("inventory_changed"):
		_player.connect("inventory_changed", Callable(self, "_on_inventory_changed"))

func _refresh_all(inv: Dictionary) -> void:
	_set_label(stone_label, "Stone", inv.get("stone", 0))
	_set_label(wood_label, "Wood", inv.get("wood", 0))
	_set_label(coal_label, "Coal", inv.get("coal", 0))
	_set_label(iron_label, "Iron", inv.get("iron", 0))

func _on_inventory_changed(key: String, new_value: int) -> void:
	match key:
		"stone":
			_set_label(stone_label, "Stone", new_value)
		"wood":
			_set_label(wood_label, "Wood", new_value)
		"coal":
			_set_label(coal_label, "Coal", new_value)
		"iron":
			_set_label(iron_label, "Iron", new_value)
		_:
			# unbekannte Ressource ignorieren (oder dynamisch ergänzen, später)
			pass

func _set_label(label: Label, title: String, value: int) -> void:
	label.text = "%s: %d" % [title, value]
