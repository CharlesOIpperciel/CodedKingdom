class_name JumpingCommand
extends Command

var impulsion = -800.0
const grid_cell_width = 32.0
const mana_cost = 20

var jump_sounds = []

func setup_jump(dir: String):
	if not player:
		print("Player reference is missing.")
		return

	match dir:
		"RIGHT":
			player.direction = 1.0
			player.get_node('AnimatedSprite').flip_h = false
			play_sound()
		"LEFT":
			player.direction = -1.0
			player.get_node('AnimatedSprite').flip_h = true
			play_sound()
		"UP":
			player.direction = 0.0
			play_sound()
		_:
			pass

	player.velocity.y = impulsion
	player.spend_mana(mana_cost)
	setup_complete = true

func update(_delta):
	if !self.setup_complete:
		return
		
	var vertical_speed = player.gravity + player.velocity.y
	
	if vertical_speed >= 0.0:
		vertical_speed = 0.0
		
	var velocity = Vector2(0.0, vertical_speed)
	player.velocity = velocity
	var _dump = self.player.move_and_slide(velocity, Vector2.UP)

func check_state() -> Command:
	if !self.setup_complete:
		return null
		
	if _should_stop():
		get_node("..").task_complete()
		setup_complete = false
		return get_node("..").to_idle()
		
	if self.player.is_on_ceiling():
		get_node("..").set_error(Global.CommandError.HIT_CEILING)
		setup_complete = false
		get_node("..").task_complete()
		return get_node("..").to_idle()
		
	if self.player.is_on_wall():
		get_node("..").set_error(Global.CommandError.HIT_WALL)
		setup_complete = false
		get_node("..").task_complete()
		return get_node("..").to_idle()
		
	if self.player.is_on_floor():
		print("Something wrong happened in this jump")
		return null
		
	if self.player.velocity.y >= 0.0:
		setup_complete = false
		
		if player.direction == 1.0 or player.direction == -1.0:
			return get_node("..").to_dashing(player.direction)
		return get_node("..").to_falling()
		
	return null
	
func play_sound():
	sounds.play_random_sound("jump")
