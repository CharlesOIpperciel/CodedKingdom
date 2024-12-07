extends WinCondition

func satisfied():
	return get_node("../../Checkpoint2").player_is_here
