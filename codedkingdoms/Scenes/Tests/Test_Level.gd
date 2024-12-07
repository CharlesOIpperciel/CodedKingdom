extends Node2D

var player
var checkpoints
var level_blueprint: Node


func _ready():
	level_blueprint = $LevelBluePrint
	player = level_blueprint.player
	checkpoints = get_tree().get_nodes_in_group("checkpoints")
	checkpoints.sort_custom(Checkpoint, "sort_checkpoints")
	player.set_checkpoint(checkpoints[0])
	checkpoints[0].set_player(player)
	checkpoints[0].reset_player()
	enable_execute()

func check_win_conditions() -> bool:
	enable_execute()
	return true

func disable_execute():
	level_blueprint.disable_execute()

func enable_execute():
	level_blueprint.enable_execute()
