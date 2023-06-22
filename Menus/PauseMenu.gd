extends ColorRect

var paused = false setget set_paused

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func set_paused(value):
	paused = value
	get_tree().paused = paused
	visible = paused
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.paused = !paused

func _on_Resume_pressed():
	self.paused = false

func _on_MainMenu_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/StartMenu.tscn")
	self.paused = false

func _on_ExitGame_pressed():
	get_tree().quit()
