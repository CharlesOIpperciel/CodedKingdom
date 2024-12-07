extends Node

onready var interpreter_scene = preload("res://Scenes/Prefabs/Levels/Interpreter/Interpreter.tscn")
var player
var hud

var limit_left
var limit_top
var limit_right
var limit_bottom


func _ready():
	player = $Player

func setup(HUD, sounds):
	hud = HUD
	hud.set_maximum_mana(player.mana)
	player.get_node("CommandManager").setup_sounds(sounds)

func disable_execute():
	hud.call("disable_execute_button")

func enable_execute():
	hud.call("enable_execute_button")

func set_camera_limits(left, top, right, bottom):
	var camera = player.get_node("Camera2D")
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
	limit_bottom = bottom
	limit_left = left
	limit_right = right
	limit_top = top

func within_limits(pos: Vector2) -> bool:
	if pos.x < limit_left:
		return false
	if pos.x > limit_right:
		return false
	# no need to handle vertical limits for now, because teleport is only sideways
	return true

func reset():
	for child in get_children():
		if child.name == "Interpreter":
			child.queue_free()
			break
	var interpreter = interpreter_scene.instance()
	interpreter.name = "Interpreter"
	add_child(interpreter)
	
func center_camera_on_player():
	player.center_camera_on_player()
