extends Area2D

export var value: int
export var readonly: bool = true
export var display: bool = false
var label
var player

func _ready():
	label = $Label
	label.visible = display
	if display:
		_display_value()
	player = get_tree().get_nodes_in_group("player")[0]

# We have to limit these values because of the display thingy
func set_value(new_value: int):
	value = new_value

func get_value():
	return value
	
func _display_value():
	if value > 999:
		label.text = ">999"
	elif value < -999:
		label.text = "<-999"
	else:
		label.text = str(value)

func can_write():
	return !readonly

func write(new_value) -> bool:
	if !readonly:
		set_value(new_value)
		_display_value()
		label.visible = true
		return true
	else:
		return false

func read() -> int:
	label.visible = true
	_display_value()
	return value
	
func hide():
	label.visible = false

func _on_NumberTile_body_entered(body):
	if body == player:
		player.set_number_tile(self)

func _on_NumberTile_body_exited(body):
	if body == player:
		player.reset_number_tile(self)
