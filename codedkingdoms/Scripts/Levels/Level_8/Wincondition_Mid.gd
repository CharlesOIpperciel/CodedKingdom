extends WinCondition


func satisfied():
	return get_node("../../FirstTP").player_is_here
