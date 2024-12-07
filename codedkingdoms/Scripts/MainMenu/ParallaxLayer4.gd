extends ParallaxLayer

export(float) var FRONT_CLOUD_SPEED = -1.0

func _process(_delta) -> void:
	self.motion_offset.x += FRONT_CLOUD_SPEED
