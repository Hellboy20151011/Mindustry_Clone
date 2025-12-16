extends Area2D

var _dir: Vector2
var _speed: float
var _damage: float
var _life: float
var _t := 0.0

func setup(direction: Vector2, speed: float, damage: float, life: float) -> void:
	_dir = direction.normalized()
	_speed = speed
	_damage = damage
	_life = life
	rotation = _dir.angle()

func _process(delta: float) -> void:
	global_position += _dir * _speed * delta

	_t += delta
	if _t >= _life:
		queue_free()
