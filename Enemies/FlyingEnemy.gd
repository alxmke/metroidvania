extends "res://Enemies/Enemy.gd"

onready var attack = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _physics_process(_delta):
	attack.attack()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass
