extends WinCondition

func satisfied():
	return get_node("../../Checkpoint3").player_is_here
