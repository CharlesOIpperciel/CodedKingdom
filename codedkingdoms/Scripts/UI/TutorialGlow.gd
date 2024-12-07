extends Light2D

var intensity_target = 0.75
var intentisity_min = 0.6
var intentisity_max = 1.2
var intensity_speed = 0.3

func _ready():
	energy = intensity_target

func _process(delta):
	energy = energy + delta * intensity_speed
	if energy > intentisity_max || energy < intentisity_min:
		intensity_speed *= -1.0
