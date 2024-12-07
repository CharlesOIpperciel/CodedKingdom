extends Node

func satisfied() -> bool:
	return get_node("../../End").player_is_here && get_node("../../../Numbers").satisfied()
