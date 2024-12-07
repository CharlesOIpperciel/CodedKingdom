extends WinCondition

func satisfied():
	return get_node("../../Checkpoint1").player_is_here
	
