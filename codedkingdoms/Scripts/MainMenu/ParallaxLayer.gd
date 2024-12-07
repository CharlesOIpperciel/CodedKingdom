extends ParallaxLayer

export(float) var SKY_SPEED = -0.05

func _process(_delta) -> void:
	self.motion_offset.x += SKY_SPEED
