extends KinematicBody2D

export var ACCELERATION: float = 512
export var SPEED: float = 64
export var FRICTION: float = 512
export var GRAVITY: float = 300
export var JUMP_FORCE: float = -150
export var SMALL_JUMP: float = JUMP_FORCE * 0.5
export var MAX_SLOPE_ANGLE: float = deg2rad(46)

var motion = Vector2.ZERO
var snap_vector = Vector2.DOWN

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _physics_process(delta):
	var x: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	snap_vector = Vector2.DOWN
	apply_horizontal_force(delta, x)
	jump(delta)
	animate(x)
	move()

func move():
	motion = move_and_slide_with_snap(
		motion, # linear_velocity
		snap_vector * 4, # snap
		Vector2.UP, # up_direction: Vector2 = Vector2( 0, 0 ),
		true, # stop_on_slope: bool = false,
		4, # max_slides: int = 4,
		MAX_SLOPE_ANGLE # floor_max_angle: float = 0.785398,
		# infinite_inertia: bool = true)
	)

# applies gravity or jump force
func jump(delta):
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		snap_vector = Vector2.ZERO
		motion.y = JUMP_FORCE
	elif Input.is_action_just_released("ui_up") and motion.y < SMALL_JUMP:
		motion.y = SMALL_JUMP
	else:
		motion.y += GRAVITY * delta

func apply_horizontal_force(delta, x):
	if is_on_floor():
		if x:
			motion.x = move_toward(motion.x, x * SPEED, ACCELERATION * delta)
		else:
			motion.x = move_toward(motion.x, 0, FRICTION * delta)
	elif x:
		motion.x = move_toward(motion.x, x * SPEED, ACCELERATION * 0.1 * delta)

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
