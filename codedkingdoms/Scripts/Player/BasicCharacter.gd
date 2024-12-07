extends KinematicBody2D
class_name BasicCharacter

export (int) var run_speed = 6000
export (int) var jump_speed = 6000
export (int) var gravity = 50
export (float) var terminal_velocity = 8000.0

var mana:int = 0
var last_checkpoint: Checkpoint
var velocity: Vector2 = Vector2(0.0, 0.0)
var target_x_position: float
var direction = 0.0
var number_tile = null

func _init():
	add_to_group("player")

func _physics_process(delta):
	$CommandManager.update(delta)

func spend_mana(mana_spent: int):
	mana -= mana_spent
	get_parent().hud.spend_mana(mana_spent)

func reset_to_last_checkpoint():
	if last_checkpoint != null:
		last_checkpoint.reset_player()
		$CommandManager.to_idle()

func has_enough_mana(mana_cost: int) -> bool:
	return self.mana >= mana_cost

func set_mana_amount(amount: int):
	self.mana = amount
	var hud = get_parent().hud
	if hud != null:
		hud.set_maximum_mana(amount)

func set_checkpoint(checkpoint: Checkpoint):
	last_checkpoint = checkpoint

func leave_group():
	remove_from_group("player")

func set_number_tile(tile):
	number_tile = tile

func reset_number_tile(tile):
	if number_tile == tile:
		number_tile = null

func center_camera_on_player():
	$Camera2D.position = Vector2()

func within_limits():
	return get_parent().within_limits(position)
