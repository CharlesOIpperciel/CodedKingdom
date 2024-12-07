extends Level

"""
direction = 1.0
r = "RIGHT"
l = "LEFT"
walk_dir = None
jump_dir = None
for level in range(4):
	if direction > 0:
		walk_dir = r
		jump_dir = l
	else:
		walk_dir = l
		jump_dir = r
		
	distance = distance_to_wall(walk_dir)
	for _ in range(distance):
		move(walk_dir)
	if level != 3:
		jump(jump_dir)
	direction *= -1
"""

func _ready():
	_set_id("level_4")
	_set_text_to_load(["objective", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# Objective
			checkpoints.activate_next_checkpoint()
			should_advance_when_dialog_complete = false
			hud.add_objective_entry("level4", "c1")
			_continue_dialog()
			_enable_execute()
		1:	# Congratulations
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true
			_continue_dialog()
		2:  # End
			get_parent().level_complete()

func advance_scene():
	current_scene_step +=1
	### Maybe move some stuff around according to where we are in the scene
	_play_scene()
