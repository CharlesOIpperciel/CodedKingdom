extends WinCondition

func satisfied():
	return get_node("../../MidPoint").player_is_here
	
