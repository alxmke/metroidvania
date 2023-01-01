extends Node

export var base_health: float = 1

signal died

onready var health: float = base_health setget set_health

# Called when the node enters the scene tree for the first time.
func _ready(): pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func set_health(value):
	health = clamp(value, 0, base_health)
	if health <= 0:
		emit_signal("died")
