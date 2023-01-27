extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_Start_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")

func _on_Load_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()