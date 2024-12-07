extends WinCondition


func satisfied():
	return get_node("../../DoubleTP").player_is_here
