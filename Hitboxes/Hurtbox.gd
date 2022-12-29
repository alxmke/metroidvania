extends Area2D

signal got_hurt(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func _on_Hurtbox_area_entered(hit):
	emit_signal("got_hurt", hit.damage)
