extends Level

"""
for _ in range(5):
	while not on_number():
		move("RIGHT")
	jump("RIGHT")
for _ in range(distance_to_wall("RIGHT")):
	move("RIGHT")
"""

func _ready():
	_set_id("level_5")
	_set_text_to_load(["introduction", "objective", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# introduction
			should_advance_when_dialog_complete = true
			_continue_dialog()
			checkpoints.activate_next_checkpoint()
		1:	# objective
			should_advance_when_dialog_complete = false
			hud.add_objective_entry("level7", "c1")
			_continue_dialog()
			_enable_execute()	
		2:
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true
			_continue_dialog()
		3:  # End
			get_parent().level_complete()

