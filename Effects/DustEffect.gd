extends Node2D

export var radius = 20
var motion: Vector2 = Vector2(
	rand_range(-10, 10), 
	rand_range(-10, -20)
)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	position += motion * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass
