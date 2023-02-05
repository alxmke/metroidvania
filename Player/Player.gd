extends KinematicBody2D

export var ACCELERATION: float = 512
export var SPEED: float = 64
export var FRICTION: float = 512
export var GRAVITY: float = 300
export var JUMP_FORCE: float = -150
export var SMALL_JUMP: float = JUMP_FORCE * 0.5
export var WALL_SLIDE_SPEED: float = -JUMP_FORCE
export var MAX_SLOPE_ANGLE: float = deg2rad(46)
export var BULLET_SPEED: float = 250
export var FIRE_RATE: float = 0.25
export var motion: Vector2 = Vector2.ZERO

const DustEffect = preload("res://Effects/DustEffect.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")
const PlayerBullet = preload("res://Player/PlayerBullet.tscn")
var PlayerStats = ResourceLoader.PlayerStats

var snap_vector: Vector2 = Vector2.DOWN
var can_coyote_jump: bool = false
var can_double_jump: bool = true
var can_fire_gun: bool = true

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var coyote_jump = $CoyoteJump
onready var gun = $Sprite/PlayerGun
onready var muzzle = $Sprite/PlayerGun/Muzzle
onready var gun_timer = $GunTimer

enum {
	MOVE,
	WALL_SLIDE,
}
var state = MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("player_died", self, "_on_died")

func _physics_process(delta):
	var x: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	match state:
		MOVE:
			move_state(delta, x)
		WALL_SLIDE:
			wall_slide_state(delta)
	animate(x)
	fire_gun()
	
func wall_slide_state(delta):
	var wall_facing = get_wall_facing()
	check_wall_jump(wall_facing)
	check_wall_drop(delta)
	check_wall_slide_down_faster(delta, WALL_SLIDE_SPEED)
	check_wall_detatch(wall_facing)
	
	motion = move_and_slide_with_snap(
		motion, # linear_velocity
		snap_vector * 4, # snap
		Vector2.UP, # up_direction: Vector2 = Vector2( 0, 0 ),
		true, # stop_on_slope: bool = false,
		4, # max_slides: int = 4,
		MAX_SLOPE_ANGLE # floor_max_angle: float = 0.785398,
		# infinite_inertia: bool = true)
	)

func check_wall_detatch(wall_facing):
	if not wall_facing or is_on_floor():
		state = MOVE
	
func check_wall_jump(wall_facing):
	if Input.is_action_just_pressed("ui_up"):
		motion.x = wall_facing * SPEED
		motion.y = JUMP_FORCE*0.8
		state = MOVE

func check_wall_slide_down_faster(delta, max_slide_speed):
	if Input.is_action_just_pressed("ui_down"):
		max_slide_speed = -JUMP_FORCE
	var friction = -GRAVITY*0.75 if sign(motion.y) == sign(GRAVITY) else GRAVITY*0.5
	motion.y = min(motion.y + (GRAVITY + friction) * delta, max_slide_speed)

func check_wall_drop(delta):
	var x = int(Input.is_action_just_pressed("ui_left")) - int(Input.is_action_just_pressed("ui_right"))
	if x:
		motion.x += x * ACCELERATION * delta
		state = MOVE
	
func get_wall_facing():
	return int(test_move(transform, Vector2.LEFT)) - int(test_move(transform, Vector2.RIGHT))
	
func check_wall_slide():
	if not is_on_floor() and is_on_wall():
		state = WALL_SLIDE
		can_double_jump = true

func move_state(delta, x):
	snap_vector = Vector2.DOWN
	apply_horizontal_force(delta, x)
	jump(delta, 1)
	move()
	check_wall_slide()
	
func fire_gun():
	if Input.is_action_pressed("fire") and can_fire_gun:
		var bullet = Utils.instance_scene_in_world(PlayerBullet, muzzle.global_position)
		bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
		bullet.velocity.x *= sprite.scale.x # multiply by sign of direction to orient horizontally
		bullet.rotation = bullet.velocity.angle()
		can_fire_gun = false
		gun_timer.start(FIRE_RATE)

func move():
	var was_on_floor: bool = is_on_floor()
	motion = move_and_slide_with_snap(
		motion, # linear_velocity
		snap_vector * 4, # snap
		Vector2.UP, # up_direction: Vector2 = Vector2( 0, 0 ),
		true, # stop_on_slope: bool = false,
		4, # max_slides: int = 4,
		MAX_SLOPE_ANGLE # floor_max_angle: float = 0.785398,
		# infinite_inertia: bool = true)
	)
	
	# just landed
	if not was_on_floor and is_on_floor():
		jump_effect()
		can_double_jump = true

	# just left ground	
	if was_on_floor and not is_on_floor():
		can_coyote_jump = true
		coyote_jump.start()

# applies gravity or jump force
func jump(delta, scalar):
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or can_coyote_jump:
			snap_vector = Vector2.ZERO
			motion.y = JUMP_FORCE * scalar
			can_coyote_jump = false
			jump_effect()
		elif can_double_jump:
			snap_vector = Vector2.ZERO
			motion.y = JUMP_FORCE * 0.75 * scalar
			can_double_jump = false
			jump_effect()
	elif Input.is_action_just_released("ui_up") and motion.y < SMALL_JUMP * scalar:
		motion.y = SMALL_JUMP
	else:
		motion.y += GRAVITY * delta / scalar

func jump_effect():
	Utils.instance_scene_in_world(JumpEffect, global_position)

func apply_horizontal_force(delta, x):
	if is_on_floor():
		if x:
			motion.x = move_toward(motion.x, x * SPEED, ACCELERATION * delta)
		else:
			motion.x = move_toward(motion.x, 0, FRICTION * delta)
	elif x:
		motion.x = move_toward(motion.x, x * SPEED, ACCELERATION * 0.1 * delta)

func create_dust_effect():
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	Utils.instance_scene_in_world(DustEffect, dust_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

# this function is called by the animation to flip the sprite
func wall_slide_animate_sprite_flip():
	sprite.scale.x = get_wall_facing()

func animate(x):
	var facing = sign(get_local_mouse_position().x)
	match state:
		MOVE:
			sprite.scale.x = facing
			if x:
				animation_player.play("run")
				animation_player.playback_speed = sign(x)*facing
			else:
				animation_player.play("idle")
				animation_player.playback_speed = 1

			if not is_on_floor():
				animation_player.play("jump")
		WALL_SLIDE:
			animation_player.play("wall_slide")

func _on_CoyoteJump_timeout():
	can_coyote_jump = false

func _on_GunTimer_timeout():
	can_fire_gun = true

func _on_Hurtbox_got_hurt(damage):
	PlayerStats.health -= damage

func _on_died():
	queue_free()
