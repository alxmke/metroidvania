extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass
