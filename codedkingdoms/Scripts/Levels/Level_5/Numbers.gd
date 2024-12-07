extends Node

onready var input = [$Read1, $Read2, $Read3]
onready var output = $Write
var sum

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_shuffle()

func _shuffle():
	sum = 0
	for i in range(3):
		var number = int(rand_range(0, 100.0))
		input[i].set_value(number)
		sum += number
	output.set_value(-999)

func satisfied() -> bool:
	return output.get_value() == sum
	
func reset():
	for i in input:
		i.hide()
	output.hide()
	_shuffle()
