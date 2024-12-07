class_name IdleCommand
extends Command

func setup(player):
	self.player = player
	self.setup_complete = true

func setup_idle():
	player.get_node('AnimatedSprite').play("Idle")
	setup_complete = true

func update(delta):
	if !setup_complete:
		return

	var velocity = Vector2(0.0, self.player.gravity * delta)
	var _dump = self.player.move_and_slide(velocity, Vector2(0.0,-1.0))

func check_state() -> Command:
	if self.player.is_on_floor():
		return null
	if !(self.player.is_on_ceiling() || self.player.is_on_floor() || self.player.is_on_wall()):
		# we pass the unlocked semaphore
		return get_node("..").to_falling()
	return null

