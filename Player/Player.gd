extends KinematicBody2D

export var ACCELERATION: float = 512
export var SPEED: float = 64
export var FRICTION: float = 512
export var GRAVITY: float = 300
export var JUMP_FORCE: float = 128
export var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _physics_process(delta):
	var x: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var on_floor: bool = is_on_floor()
	
	if x != 0 and on_floor:
		motion.x = move_toward(motion.x, x * SPEED, ACCELERATION * delta)
	elif on_floor:
		motion.x = move_toward(motion.x, 0, FRICTION * delta)
	elif x != 0:
		motion.x = move_toward(motion.x, x * SPEED, ACCELERATION/10 * delta)
	
	if on_floor and Input.is_action_just_pressed("ui_up"):
		motion.y = -JUMP_FORCE
	elif Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
		motion.y = -JUMP_FORCE/2
	else:
		motion.y += GRAVITY * delta
	
	animate(x)
	motion = move_and_slide(motion, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func animate(x):
	if x:
		sprite.scale.x = sign(x)
		animation_player.play("run")
	else:
		animation_player.play("idle")
	
	if not is_on_floor():
		animation_player.play("jump")
