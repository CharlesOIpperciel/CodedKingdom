extends Level

"""
distance = distance_to_wall("RIGHT")
for _ in range(distance):
	move("RIGHT")
jump("LEFT")
distance = distance_to_wall("LEFT")
for _ in range(distance):
	move("LEFT")
"""

func _ready():
	_set_id("level_3")
	_set_text_to_load(["objective", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# Objective
			should_advance_when_dialog_complete = false
			checkpoints.activate_next_checkpoint()
			hud.add_objective_entry("level3", "c1")
			_continue_dialog()
			_enable_execute()
		1:	# Congratulations
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true
			_continue_dialog()
		2:  # End
			get_parent().level_complete()
