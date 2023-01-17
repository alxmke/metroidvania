extends Camera2D

var shake = 0

onready var timer = $Timer

func _ready():
	# warning-ignore:return_value_discarded
	Events.connect("add_screenshake", self, "screenshake")

func _physics_process(_delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func screenshake(amount, duration):
	shake = amount
	timer.start(duration)

func _on_Timer_timeout():
	shake = 0	
