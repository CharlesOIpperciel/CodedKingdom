class_name TeleportCommand
extends Command

var target_position: Vector2
const grid_cell_width = 32.0
var tp_distance: int
const mana_cost = 1000
var first_animation_complete = false
var second_animation_complete = false
var out_of_bounds = false

func setup_teleport(distance: int, direction: String):
	first_animation_complete = false
	second_animation_complete = false
	tp_distance = distance;

	match direction:
		"RIGHT":
			player.direction = 1.0
			player.get_node('AnimatedSprite').flip_h = false
			#player.get_node('AnimatedSprite').play("Walk")
		"LEFT":
			player.direction = -1.0
			player.get_node('AnimatedSprite').flip_h = true
			#player.get_node('AnimatedSprite').play("Walk")
		_ : 
			# Invalid input should have been caught before we arrive here
			pass
	target_position = player.position
	target_position.x += (grid_cell_width * player.direction * distance)
	out_of_bounds = !self.player.get_parent().within_limits(Vector2(target_position))
	player.target_x_position = target_position.x
	player.spend_mana(mana_cost)
	$FirstAnimationTimer.start()
	player.get_node('AnimatedSprite').play("Teleport1")
	
	self.setup_complete = true
	
 #what happens each game loop
func update(_delta):
	if !(self.setup_complete && first_animation_complete):
		return
	if !out_of_bounds:
		player.position.x = player.target_x_position
	first_animation_complete = false
	$SecondAnimationTimer.start()
	player.get_node('AnimatedSprite').play("Teleport2")
	
# Either returns the new state or nothing if we are to stay in this state
func check_state() -> Command:
	if !(self.setup_complete && second_animation_complete):
		return null
	second_animation_complete = false
	# just to force phyics update
	var _collision = player.move_and_slide(Vector2(0.001 ,0.0), Vector2.UP)
	
	if self.player.is_on_ceiling():
		get_node("..").set_error(Global.CommandError.TELEPORT_IN_WALL)
		
	elif self.player.is_on_wall():
		get_node("..").set_error(Global.CommandError.TELEPORT_IN_WALL)
	
	if out_of_bounds:
		get_node("..").set_error(Global.CommandError.TELEPORT_OUT_OF_BOUNDS)
		
	command_complete()
	return get_node("..").to_idle()

func command_complete():
	get_node("..").task_complete()

# This represents the time the first teleport animation takes.
# Replace this by the teleport animations end signals once we have them.
func _on_FirstAnimationTimer_timeout():
	first_animation_complete = true

# This represents the time the first teleport animation takes.
# Replace this by the teleport animations end signals once we have them.
func _on_SecondAnimationTimer_timeout():
	second_animation_complete = true



