class_name DashingCommand
extends Command

var direction: float
var friction = 100.0
var impulsion = 20000.0
const grid_cell_width = 32.0

# setup dash direction
func setup_dash(dir: float):
	direction = dir
	var target_x_position = player.position.x
	target_x_position += (2.0 * grid_cell_width * player.direction)
	player.target_x_position = target_x_position
	player.velocity.x = impulsion * direction
	setup_complete = true
	play_sound()

# we will update the jump as long as the player is going up
func update(delta):
	if !self.setup_complete:
		return
	var horizontal_speed = player.velocity.x + friction * direction * -1.0
	player.velocity = Vector2(horizontal_speed, 0.0)
	var displacement = delta * horizontal_speed
	var _dump = self.player.move_and_slide(Vector2(displacement, 0.0), Vector2.UP)

# Either returns the new state or nothing if we are to stay in this state
func check_state() -> Command:
	if !self.setup_complete:
		return null
	if _should_stop():
		setup_complete = false
		get_node("..").task_complete()
		return get_node("..").to_idle()
	if self.player.is_on_ceiling():
		setup_complete = false
		get_node("..").set_error(Global.CommandError.HIT_CEILING)
		get_node("..").task_complete()
		return get_node("..").to_idle()
	if self.player.is_on_wall():
		setup_complete = false
		get_node("..").set_error(Global.CommandError.HIT_WALL)
		get_node("..").task_complete()
		return get_node("..").to_idle()
	if self.player.is_on_floor():
		# This would only happen if something hits the player from underneath
		print("Something wrong happend in this dash")
		return null
		
	if (self.player.direction < 0 && self.player.position.x < self.player.target_x_position) || (self.player.direction > 0 && self.player.position.x > self.player.target_x_position):
		player.position.x = player.target_x_position
		setup_complete = false
		return get_node("..").to_falling()
	return null

func play_sound():
	sounds.play_random_sound("jump")
