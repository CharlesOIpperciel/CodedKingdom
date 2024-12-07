extends Level
"""
r = "RIGHT"
l = "LEFT"
number = -1
direction = l
while True:
	move(direction)
	if on_number():
		number = read_number()
		if number == -1:
			direction = l
		elif number == 1:
			direction = r
		elif number == 0:
			break
		jump(direction)
"""

func _ready():
	_set_id("level_6")
	_set_text_to_load(["introduction", "objective", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# introduction
			should_advance_when_dialog_complete = true
			_continue_dialog()
			checkpoints.activate_next_checkpoint()
		1:	# objective
			should_advance_when_dialog_complete = false
			hud.add_objective_entry("level8", "c1")
			_continue_dialog()
			_enable_execute()	
		2:
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true
			_continue_dialog()
		3:  # End
			get_parent().level_complete()
