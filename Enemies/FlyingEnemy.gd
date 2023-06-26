extends "res://Enemies/Enemy.gd"

export(float) var ACCELERATION = 100

var MainInstances = ResourceLoader.MainInstances

onready var attack = $Hitbox
onready var collision = $CollisionShape2D
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _physics_process(delta):
	var player = MainInstances.player
	if player != null:
		chase_player(player, delta)
	attack.attack()

func chase_player(player, delta):
	var direction = (player.global_position - global_position).normalized()
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(BASE_SPEED)
	attack.scale.x = sign(motion.x)
	collision.position.x = -sign(motion.x)
	sprite.scale.x = sign(motion.x)
	motion = move_and_slide(motion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass
