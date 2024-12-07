extends WinCondition


func satisfied():
	return get_node("../../Mid").player_is_here
