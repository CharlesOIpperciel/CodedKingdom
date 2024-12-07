extends Level

"""
distance = distance_to_wall("RIGHT")
sum = 0
for _ in range(distance):
	move("RIGHT")
	if on_number():
		if not can_write():
			number = read_number()
			sum += number
		else:
			write_number(sum)

"""


func _ready():
	_set_id("level_7")
	_set_text_to_load(["introduction", "objective", "congratulations"])

func _play_scene():
	match current_scene_step:
		0:	# introduction
			should_advance_when_dialog_complete = true
			_continue_dialog()
		1:	# objective
			hud.add_objective_entry("level6", "c1")
			should_advance_when_dialog_complete = false
			_continue_dialog()
			_enable_execute()	
		2:
			hud.mark_objective_as_complete()
			should_advance_when_dialog_complete = true
			_continue_dialog()
		3:  # End
			get_parent().level_complete()

func _reset():
	$Numbers.reset()
