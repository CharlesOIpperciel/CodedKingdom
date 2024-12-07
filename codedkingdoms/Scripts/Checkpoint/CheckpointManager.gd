extends Node

# List to store all checkpoints
var checkpoints = []
# Track the current checkpoint index
var current_player_checkpoint_index = 0 
var currently_glowing_checkpoint = 0
var player

func _ready():
	checkpoints = get_tree().get_nodes_in_group("checkpoints")
	checkpoints.sort_custom(Checkpoint, "sort_checkpoints")
	player = get_tree().get_nodes_in_group("player")[0]
	deactivate_all_checkpoints()
	player.set_checkpoint(checkpoints[0])
	checkpoints[0].reset_player()

func set_player_at(checkpoint_index: int):
	if checkpoint_index < checkpoints.size():
		current_player_checkpoint_index = checkpoint_index
		player.set_checkpoint(checkpoints[current_player_checkpoint_index])

func set_player_at_next_checkpoint():
	current_player_checkpoint_index += 1
	if current_player_checkpoint_index < checkpoints.size():
		player.set_checkpoint(checkpoints[current_player_checkpoint_index])
		
# Deactivates all checkpoint lights
func deactivate_all_checkpoints():
	for checkpoint in checkpoints:
		checkpoint.set_light_state(false)

func activate_checkpoint_at(checkpoint_index: int):
	deactivate_all_checkpoints()
	if checkpoint_index < checkpoints.size():
		currently_glowing_checkpoint = checkpoint_index
		checkpoints[currently_glowing_checkpoint].set_light_state(true)
	
# Finds and activates the next closest checkpoint
func activate_next_checkpoint():
	# Deactivate all lights first
	deactivate_all_checkpoints()
	# Check if the next checkpoint index is within bounds
	currently_glowing_checkpoint += 1
	if currently_glowing_checkpoint < checkpoints.size():
		# Activate the next checkpoint's light
		var next_checkpoint = checkpoints[currently_glowing_checkpoint]
		next_checkpoint.set_light_state(true)
		
func check_win_conditions() -> bool:
	if current_player_checkpoint_index < checkpoints.size():
		return checkpoints[current_player_checkpoint_index].win_condition_satisfied()
	return false

func check_win_conditions_at(checkpoint_index: int) -> bool:
	if checkpoint_index < checkpoints.size():
		return checkpoints[checkpoint_index].win_condition_satisfied()
	return false
	
