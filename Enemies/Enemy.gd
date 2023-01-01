extends KinematicBody2D

export var BASE_SPEED: float = 15

var motion: Vector2 = Vector2.ZERO

onready var enemy_stats = $EnemyStats

# Called when the node enters the scene tree for the first time.
func _ready(): pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func _on_Hurtbox_got_hurt(damage):
	enemy_stats.health -= damage

func _on_EnemyStats_died():
	queue_free()
