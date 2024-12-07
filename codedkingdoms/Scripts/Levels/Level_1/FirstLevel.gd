extends Level

var elements = {
	"slider": false,
	"play": false,
	"stop": false,
	"reset": false,
	"journal": false,
	"minimap": false,
}

signal tutorial_interaction

func _ready():
	_set_id("level_1")
	_set_text_to_load(["introduction", "journal", "slider", "walking", "execute", "stop", "reset", "minimap", "move_twice", "move_4_times"])
	hud.tutorial_connect_signals(self)
	

func _play_scene():
	match current_scene_step:
		0:  # introduction
			should_advance_when_dialog_complete = true
			_continue_dialog()
		1:  # journal
			hud.add_objective_entry("level1", "c1")
			should_advance_when_dialog_complete = false
			_wait_for_signal("journal", true)
			_continue_dialog()
		2:  #slider
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level1", "c2")
			_wait_for_signal("slider", true)
			_continue_dialog()
		3:  # walking
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level1", "c3")
			should_advance_when_dialog_complete = true
			_continue_dialog()
		4:	# execute
			should_advance_when_dialog_complete = false
			checkpoints.activate_next_checkpoint()
			_enable_execute()
			_continue_dialog()
			_wait_for_signal("play", false)
		5:	# stop
			should_advance_when_dialog_complete = true
			_continue_dialog()
		6:	# reset
			should_advance_when_dialog_complete = false
			_continue_dialog()
			_wait_for_signal("reset", true)
		7:	# minimap
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level1", "c4")
			_continue_dialog()
			_wait_for_signal("minimap", true)
		8:	# move_twice
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level1", "c5")
			_advance_checkpoint()
			_continue_dialog()
			_enable_execute()
		9:	# move_4_times
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level1", "c6")
			_continue_dialog()
			_enable_execute()			
			_advance_checkpoint()
		10: # success!
			hud.mark_objective_as_complete()
			hud.tutorial_disconnect_signals(self)
			hud.disable_all_tutorial_glow()
			get_parent().level_complete()

func _wait_for_signal(element, advance):
	elements[element] = true
	hud.tutorial_glow.toggle_on(element)
	yield(self, "tutorial_interaction")
	elements[element] = false
	if advance:
		_advance_scene()

func _on_slider_pressed():
	signal_element("slider")

func _on_stop_pressed():
	signal_element("stop")

func _on_execute_pressed():
	signal_element("play")

func _on_reset_pressed():
	signal_element("reset")

func _on_journal_pressed():
	signal_element("journal")
	
func _on_minimap_pressed():
	signal_element("minimap")

func signal_element(elem):
	if elements[elem]:
		emit_signal("tutorial_interaction")
	hud.tutorial_glow.toggle_off(elem)
