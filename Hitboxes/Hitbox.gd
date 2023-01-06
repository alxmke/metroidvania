extends Area2D

export var damage: float = 1
export var cooldown_time: float = 1

onready var cooldown = $Cooldown
onready var attack_area = $CollisionShape2D

enum {
	WAITING,
	CAN_ATTACK,
	CANT_ATTACK,
}
var state = CAN_ATTACK

signal hit(damage)
signal cant_hit

func _ready(): pass

func attack():	
	match state:
		WAITING:
			pass
		CANT_ATTACK:
			emit_signal('cant_hit')
			state = WAITING
		CAN_ATTACK:
			emit_signal("hit", damage)
			state = CANT_ATTACK
			cooldown.start(cooldown_time)

func _on_Cooldown_timeout():
	state = CAN_ATTACK
	
func _on_Hitbox_hit(_damage):
	attack_area.disabled = false

func _on_Hitbox_cant_hit():
	attack_area.disabled = true
