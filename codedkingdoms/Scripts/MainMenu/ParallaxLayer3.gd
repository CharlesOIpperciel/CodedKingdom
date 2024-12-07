extends ParallaxLayer

export(float) var CLOUD_SPEED = -0.8

func _process(_delta) -> void:
	self.motion_offset.x += CLOUD_SPEED
