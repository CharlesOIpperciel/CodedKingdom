extends Node

export var move_speed: float = 50.0
export var min_pause_time: float = 1.0
export var max_pause_time: float = 4.0
export var wander_distance: float = 100.0

var conversation_box_scene = preload("res://Scenes/UI/ConversationBox.tscn")
var direction: float = 1.0
var target_position: Vector2
var is_moving: bool = false
var grand_wizard: Node2D
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = OS.get_unix_time()
	grand_wizard = get_node("..")
	target_position = Vector2(grand_wizard.position.x + wander_distance * direction, grand_wizard.position.y)
	_start_wandering()

func _start_wandering():
	var pause_duration = rng.randf_range(min_pause_time, max_pause_time)
	yield(get_tree().create_timer(pause_duration), "timeout")
	grand_wizard.get_node("AnimatedSprite").flip_h = direction < 0.0
	is_moving = true

func _process(delta):
	if is_moving:
		_wander(delta)

func _wander(delta):
	var distance = move_speed * delta * direction
	grand_wizard.position.x += distance
	if (direction > 0.0 and grand_wizard.position.x >= target_position.x) or (direction < 0.0 and grand_wizard.position.x <= target_position.x):
		grand_wizard.position.x = target_position.x
		grand_wizard.get_node("AnimatedSprite").play("Idle")
		is_moving = false
		direction *= -1
		target_position = Vector2(grand_wizard.position.x + wander_distance * direction, grand_wizard.position.y)
		_start_wandering()

func start_dialog(dialogs):
	var conversation_box = conversation_box_scene.instance()
	conversation_box.connect("dialog_complete", self, "_dialog_complete")
	conversation_box.add_icon("GrandWizard")
	for dialog in dialogs:
		conversation_box.queue_text(dialog)
	add_child(conversation_box)

func _dialog_complete():
	get_tree().root.get_node("LevelLoader/Level2").check_win_conditions()
	pass
