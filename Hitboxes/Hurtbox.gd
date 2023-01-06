extends Area2D

# the hurtbox is entered by attack areas (hitboxes) that will pulse a damage tick signal when their
# attack is triggered by the entity managing it

signal got_hurt(damage)

# Called when the node enters the scene tree for the first time.
func _ready():pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta): pass

func _on_Hurtbox_area_entered(hit):
	emit_signal("got_hurt", hit.damage)
