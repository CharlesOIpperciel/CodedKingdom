extends Node

func satisfied() -> bool:
	return get_node("../../End").player_is_here
