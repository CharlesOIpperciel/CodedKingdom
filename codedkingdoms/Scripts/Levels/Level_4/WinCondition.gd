extends WinCondition

func satisfied():
	return get_node("../../End").player_is_here
	
