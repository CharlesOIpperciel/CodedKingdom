class_name WalkingCommand
extends Command

var target_position: Vector2
const grid_cell_width = 32.0
const mana_cost = 10

var footstep_timer = 0.0
const footstep_interval = 0.25

func setup_movement(direction: String):
	match direction:
		"RIGHT":
			player.direction = 1.0
			player.get_node('AnimatedSprite').flip_h = false
			player.get_node('AnimatedSprite').play("Walk")
		"LEFT":
			player.direction = -1.0
			player.get_node('AnimatedSprite').flip_h = true
			player.get_node('AnimatedSprite').play("Walk")
		_ : 
			# Invalid input should have been caught before we arrive here
			pass
	target_position = player.position
	target_position.x += (grid_cell_width * player.direction)
	player.target_x_position = target_position.x
	player.spend_mana(mana_cost)
	self.setup_complete = true

func update(delta):
	if !self.setup_complete:
		return
	
	footstep_timer += delta
	if footstep_timer >= footstep_interval:
		play_footstep_sound()
		footstep_timer = 0.0

	var displacement = delta * player.run_speed * player.direction
	var velocity = Vector2(displacement, player.gravity)
	player.velocity = velocity
	var _dump = player.move_and_slide(velocity, Vector2.UP)

# Either returns the new state or nothing if we are to stay in this state
func check_state() -> Command:
	if !self.setup_complete:
		return null
	if self.player.is_on_ceiling():
		get_node("..").set_error(Global.CommandError.HIT_CEILING)
		command_complete()
		return get_node("..").to_idle()
		
	if self.player.is_on_wall():
		get_node("..").set_error(Global.CommandError.HIT_WALL)
		command_complete()
		return get_node("..").to_idle()
		
	if self.player.is_on_floor():
			# Command is complete and player is grounded -> return idle
		if (self.player.direction < 0 && self.player.position.x <= target_position.x) || (self.player.direction > 0 && self.player.position.x >= target_position.x):
			self.player.position.x = target_position.x
			command_complete()
			return get_node("..").to_lambda()
		else:
			return null
	if !(self.player.is_on_ceiling() || self.player.is_on_floor() || self.player.is_on_wall()):
		return get_node("..").to_falling()
		
	return null

func command_complete():
	self.setup_complete = false
	get_node("..").task_complete()

func play_footstep_sound():
	sounds.play_random_sound("foot_step")
