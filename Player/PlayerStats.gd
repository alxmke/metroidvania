extends Resource
class_name PlayerStats

var base_health: float = 4
var health: float = base_health setget set_health

signal player_health_changed(value)
signal player_died

func set_health(value):
	if value < health:
		Events.emit_signal("add_screenshake", 0.25, 0.5)
	health = clamp(value, 0, base_health)
	emit_signal("player_health_changed", value)
	if health <= 0:
		emit_signal("player_died")
