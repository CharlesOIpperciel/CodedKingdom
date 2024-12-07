extends Command
class_name Falling

func setup_fall():
	setup_complete = true

func update(_delta):
	if !self.setup_complete:
		return
	var vertical_speed = player.gravity + player.velocity.y
	if vertical_speed >= player.terminal_velocity:
		vertical_speed = player.terminal_velocity
	var velocity = Vector2(0.0, vertical_speed)
	player.velocity = velocity
	var _dump = self.player.move_and_slide(velocity, Vector2.UP)

# Either returns the new state or nothing if we are to stay in this state
func check_state() -> Command:
	if _should_stop():
		get_node("..").task_complete()
		return get_node("..").to_idle()
	if !self.setup_complete:
		return null		
	if self.player.is_on_ceiling():
		get_node("..").task_complete()
		get_node("..").set_error(Global.CommandError.HIT_CEILING)
		return get_node("..").to_idle()
	if self.player.is_on_wall():
		get_node("..").set_error(Global.CommandError.HIT_WALL)
		get_node("..").task_complete()
		return get_node("..").to_idle()
	if self.player.is_on_floor():
		get_node("..").task_complete()
		return get_node("..").to_idle()
		
	return null
