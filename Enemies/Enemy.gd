extends KinematicBody2D

export var BASE_SPEED: float = 15

var motion: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready(): pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass


func _on_Hurtbox_got_hurt(damage):
	queue_free()
