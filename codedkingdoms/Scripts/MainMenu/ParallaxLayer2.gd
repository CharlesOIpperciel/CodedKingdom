extends ParallaxLayer

export(float) var MOON_SPEED = -0.1

func _process(_delta) -> void:
	self.motion_offset.x += MOON_SPEED
