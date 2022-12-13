extends KinematicBody2D

export var ACCELERATION: float = 20
export var SPEED: float = 100
export var FRICTION: float = 20

var motion = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _physics_process(delta):
	var input_vector: Vector2
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		motion = motion.move_toward(input_vector * SPEED, ACCELERATION)
	else:
		motion = motion.move_toward(input_vector, FRICTION)
	motion = move_and_slide(motion)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta): pass
