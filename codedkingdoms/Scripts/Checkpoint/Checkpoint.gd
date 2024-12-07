extends Area2D
class_name Checkpoint

export var scene_index: int
export var replenish_mana_amount: int
export var player_flip_h_on_reset: bool = false

var minimap_icon = "checkpoint"

var win_condition: Node
var last_checkpoint: Checkpoint
onready var light_2d = $Light2D

var player_is_here = false
var player
var manager

func _init():
	add_to_group("checkpoints")

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	win_condition = get_node_or_null("WinCondition")

func reset_player():
	if player:  # Ensure player exists
		player.set_mana_amount(replenish_mana_amount)
		player.position = position
		player.get_node('AnimatedSprite').flip_h = player_flip_h_on_reset

func set_player(p):
	player = p

func win_condition_satisfied():
	if win_condition != null:
		return win_condition.satisfied()
	else:
		return true

func _on_Area2D_body_entered(body):
	if body == player:
		player_is_here = true

func _on_Area2D_body_exited(body):
	if body == player:
		player_is_here = false

static func sort_checkpoints(a, b):
	return a.scene_index < b.scene_index
	
func leave_group():
	remove_from_group("checkpoints")

func set_light_state(is_visible):
	light_2d.visible = is_visible

