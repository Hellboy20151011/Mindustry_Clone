extends Node2D

@export var weapon_data: WeaponData
@export var projectile_lifetime: float = 1.5

@onready var muzzle: Node2D = $Muzzle

var _cooldown := 0.0

func _process(delta: float) -> void:
	# Rotation zur Maus
	look_at(get_global_mouse_position())

	# Cooldown runterzählen
	_cooldown = maxf(0.0, _cooldown - delta)

	if weapon_data == null:
		return

	if Input.is_action_pressed("shoot") and _cooldown <= 0.0:
		fire()
		_cooldown = 1.0 / weapon_data.fire_rate


func fire() -> void:
	if weapon_data == null:
		push_error("WeaponData not set!")
		return

	var pellets := weapon_data.shots_per_trigger
	var spread := deg_to_rad(weapon_data.spread_deg)

	for i in pellets:
		var p = weapon_data.projectile_scene.instantiate()

		# WICHTIG: IM AKTUELLEN LEVEL einfügen – NICHT root
		get_tree().current_scene.add_child(p)

		p.global_position = muzzle.global_position

		var base_dir := (get_global_mouse_position() - muzzle.global_position).normalized()
		var angle_offset := 0.0

		if pellets > 1:
			var t := float(i) / float(pellets - 1)
			angle_offset = lerp(-spread / 2.0, spread / 2.0, t)

		var dir := base_dir.rotated(angle_offset)

		p.setup(
			dir,
			weapon_data.projectile_speed,
			weapon_data.damage,
			projectile_lifetime
		)
