extends WinCondition


func satisfied():
	return get_node("../../EndPuzzle").player_is_here
