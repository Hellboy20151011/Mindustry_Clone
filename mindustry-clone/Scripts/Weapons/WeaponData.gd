extends Resource
class_name WeaponData

@export var weapon_id: String
@export var projectile_scene: PackedScene
@export var damage: float = 10
@export var fire_rate: float = 6.0 # Schuss pro Sekunde
@export var projectile_speed: float = 900.0
@export var spread_deg: float = 0.0
@export var shots_per_trigger: int = 1
@export var energy_cost: int = 0
