extends Level

"""
move("RIGHT")
move("RIGHT")
--
teleport(2,"RIGHT")
--
teleport(6,"RIGHT")
---
def recur_fibo(n):
   if n <= 1:
	   return n
   else:
	   return(recur_fibo(n-1) + recur_fibo(n-2))
tp_dist = 0
for i in range(11):
   tp_dist += recur_fibo(i)

teleport(tp_dist, "RIGHT")

"""
	
func _ready():
	_set_id("level_8")
	_set_text_to_load(["introduction", "teleport_1", "teleport_2","hard_part"])

func _play_scene():
	match current_scene_step:
		0: #this is the walk to the edge
			_continue_dialog()
		1:
			_enable_execute()
			hud.add_objective_entry("level5", "c1")
			checkpoints.activate_checkpoint_at(1)
		2: #now we are at the edge learn to TP
			_continue_dialog()
		3:
			_advance_checkpoint()
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level5", "c2")
			_enable_execute()
		4: #now we need to teleport twice in a row
			_continue_dialog()
		5:
			_advance_checkpoint()
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level5", "c3")
			_enable_execute()
		6: #now we need to do recurrsion to get to the end which is far as fuck
			_continue_dialog()
		7: #we win
			_advance_checkpoint()
			hud.mark_objective_as_complete()
			hud.add_objective_entry("level5", "c4")
			_enable_execute()
		8:
			hud.mark_objective_as_complete()
			get_parent().level_complete()
