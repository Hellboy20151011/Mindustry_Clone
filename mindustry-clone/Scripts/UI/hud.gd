extends CanvasLayer

@export var player_path: NodePath

@onready var stone_label: Label = %StoneLabel
@onready var wood_label: Label = %WoodLabel
@onready var coal_label: Label = %CoalLabel
@onready var iron_label: Label = %IronLabel

# Player stat labels
@onready var health_label: Label = %HealthLabel
@onready var shield_label: Label = %ShieldLabel
@onready var speed_label: Label = %SpeedLabel
@onready var build_speed_label: Label = %BuildSpeedLabel

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

	# Live-Updates for inventory
	if _player.has_signal("inventory_changed"):
		_player.connect("inventory_changed", Callable(self, "_on_inventory_changed"))
	
	# Live-Updates for stats
	if _player.has_signal("health_changed"):
		_player.connect("health_changed", Callable(self, "_on_health_changed"))
	if _player.has_signal("shield_changed"):
		_player.connect("shield_changed", Callable(self, "_on_shield_changed"))
	
	# Initial stats display
	if _player.has_method("get_stats"):
		var stats = _player.call("get_stats")
		_update_all_stats(stats)

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

# Player stat update functions
func _on_health_changed(current: float, maximum: float) -> void:
	health_label.text = "Health: %.0f/%.0f" % [current, maximum]

func _on_shield_changed(current: float, maximum: float) -> void:
	shield_label.text = "Shield: %.0f/%.0f" % [current, maximum]

## Update all stat displays
func _update_all_stats(stats: Dictionary) -> void:
	health_label.text = "Health: %.0f/%.0f" % [stats.get("current_health", 0), stats.get("max_health", 0)]
	shield_label.text = "Shield: %.0f/%.0f" % [stats.get("current_shield", 0), stats.get("max_shield", 0)]
	speed_label.text = "Speed: %.0f" % stats.get("max_speed", 0)
	build_speed_label.text = "Build Speed: %.1fx" % stats.get("build_speed", 1.0)
