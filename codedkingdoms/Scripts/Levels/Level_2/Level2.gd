extends Level

func _ready():
	_set_id("level_2")
	_set_text_to_load(["introduction", "for_loop", "distance_to_wall", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# introduction
			should_advance_when_dialog_complete = true
			_continue_dialog()
		1:	# for loop
			should_advance_when_dialog_complete = false
			_continue_dialog()
			hud.add_objective_entry("level2", "c1")
			checkpoints.activate_next_checkpoint()
			_enable_execute()
		2:	# distance to wall
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level2", "c2")
			_advance_checkpoint()
			_continue_dialog()
			_enable_execute()
		3:	# congratulations
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true			
			_continue_dialog()
		4: # end
			get_parent().level_complete()
