extends Node2D
class_name Level

### GAME ELEMENTS
onready var sounds = get_node("../Sounds")
onready var text_manager = get_node("../TextManager")
onready var hud = get_node("../HUD")

### SCENE ELEMENTS
var checkpoints
var player
onready var base_level = $BaseLevel
onready var mp = hud.get_node("CanvasLayer/Minimap")
var level_id

### DIALOGS
var text_to_load
var current_dialogue = 0

### SCENE STEPS
var current_scene_step = 0
var current_checkpoint = 0
var should_advance_when_dialog_complete = true

### CAMERA LIMITS
export var left_limit: int
export var top_limit: int
export var right_limit: int
export var bottom_limit: int

func _ready():
	base_level.setup(hud, sounds)
	base_level.set_camera_limits(left_limit, top_limit, right_limit, bottom_limit)
	player = base_level.player
	_disable_execute()
	checkpoints = get_node("Checkpoints")
	mp._setCheckpoints(checkpoints.get_children())
	yield(get_tree().create_timer(1.0), "timeout")
	_play_scene()

func master_reset():
	_reset()
	_reset_base_level()

func _reset_base_level():
	base_level.reset()

# Override if there is a special mechanic to reset in this level
func _reset():
	pass

func _set_id(id):
	level_id = id
	
func _set_text_to_load(text):
	text_to_load = text

func _play_scene():
	push_error("_play_scene() must be implemented for level %s" % level_id)
	return

func _advance_scene():
	current_scene_step +=1
	### Maybe move some stuff around according to where we are in the scene
	_play_scene()

func check_win_conditions() -> bool:
	if checkpoints.check_win_conditions():
		_disable_execute()
		_advance_scene()
		return true
	else:
		return false
		
func dialog_complete():
	if should_advance_when_dialog_complete:
		_advance_scene()

func _continue_dialog():
	text_manager.start_dialog(level_id, text_to_load[current_dialogue])
	current_dialogue += 1

func _disable_execute():
	base_level.disable_execute()

func _enable_execute():
	base_level.enable_execute()
	
func _advance_checkpoint():
	checkpoints.set_player_at_next_checkpoint()
	checkpoints.activate_next_checkpoint()
	player.reset_to_last_checkpoint()

