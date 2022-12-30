extends Node2D

var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first timeS.
func _ready():
	pass

func _physics_process(delta):
	position += velocity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_Hitbox_body_entered(_body):
	queue_free()

func _on_Hitbox_area_entered(_area):
	queue_free()
