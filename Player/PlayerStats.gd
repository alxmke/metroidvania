extends Resource
class_name PlayerStats

var base_health: float = 4
var health: float = base_health setget set_health

signal player_died

func set_health(value):
	health = clamp(value, 0, base_health)
	if health <= 0:
		emit_signal("player_died")
