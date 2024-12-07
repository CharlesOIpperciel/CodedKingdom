extends Node2D

export var move_speed: float = 50.0
export var min_pause_time: float = 1.0
export var max_pause_time: float = 4.0
export var wander_distance: float = 100.0

var direction: float = 1.0
var target_position: Vector2
var is_moving: bool = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = OS.get_unix_time()
	target_position = Vector2(position.x + wander_distance * direction, position.y)
	_start_wandering()

func _start_wandering():
	var pause_duration = rng.randf_range(min_pause_time, max_pause_time)
	yield(get_tree().create_timer(pause_duration), "timeout")
	get_node("AnimatedSprite").flip_h = direction < 0.0
	is_moving = true
	
func _process(delta):
	if is_moving:
		_wander(delta)

func _wander(delta):
	var distance = move_speed * delta * direction
	position.x += distance
	if (direction > 0.0 and position.x >= target_position.x) or (direction < 0.0 and position.x <= target_position.x):
		position.x = target_position.x
		get_node("AnimatedSprite").play("Idle")
		is_moving = false
		direction *= -1
		target_position = Vector2(position.x + wander_distance * direction, position.y)
		_start_wandering()

