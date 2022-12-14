extends "res://Enemies/Enemy.gd"

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

var state

onready var sprite = $Sprite
onready var floor_left = $FloorLeft
onready var floor_right = $FloorRight
onready var wall_right = $WallRight
onready var wall_left = $WallLeft
onready var attack = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	state = WALKING_DIRECTION

func _physics_process(_delta):
	match state:
		DIRECTION.RIGHT:
			motion.x = BASE_SPEED
			if not floor_right.is_colliding() or wall_right.is_colliding():
				state = DIRECTION.LEFT
		DIRECTION.LEFT:
			motion.x = -BASE_SPEED
			if not floor_left.is_colliding() or wall_left.is_colliding():
				state = DIRECTION.RIGHT
	sprite.scale.x = sign(motion.x)
	attack.scale.x = sign(motion.x)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))
	attack.attack()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass
