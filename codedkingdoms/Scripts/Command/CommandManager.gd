class_name CommandManager
extends Node

var player: KinematicBody2D
onready var idle_scene = get_node("Idle")
onready var walk_scene = get_node("Walking")
onready var fall_scene = get_node("Falling")
onready var jump_scene = get_node("Jumping")
onready var lambda_scene = get_node("Lambda")
onready var teleport_scene = get_node("Teleport")
onready var dashing_scene = get_node("Dashing")

onready var scenes = [idle_scene, walk_scene, fall_scene, jump_scene, lambda_scene, teleport_scene, dashing_scene]

var current_command: Command
var current_command_mutex: Mutex
var semaphore: BinarySemaphore

var error

const walk_mana_cost = 10
const teleport_mana_cost = 1000
const jump_mana_cost = 20

# # # COMMAND MANAGER SETUP # # #
func _init():
	semaphore = BinarySemaphore.new()

func _ready():
	error = Global.CommandError.NONE
	current_command_mutex = Mutex.new()
	current_command_mutex.lock()
	
	self.player = get_node("..")
	for scene in scenes:
		scene.setup(player)
	idle_scene.setup_idle()
	self.current_command = idle_scene
	current_command_mutex.unlock()

func setup_sounds(sounds):
	for scene in scenes:
		scene.setup_sounds(sounds)

func update(delta):
	self.current_command.update(delta)
	var next_state = self.current_command.check_state()
	if next_state != null:
		_change_state(next_state)
# # # # # # # # # # # # # # # # # # # # # # # #

# # # PLAYER ACTIONS # # #
func walk(direction):
	# should first check if we can transition to walk and do stuff
	if !direction is String:
		return "WrongDirection"
	if !self.player.has_enough_mana(walk_mana_cost):
		# TODO : display somthing to the player
		return "Oom"
	if !(direction == "RIGHT" || direction == "LEFT"):
		# TODO : display something to the player
		return "WrongWay"
	walk_scene.setup_movement(direction)
	_change_state(walk_scene)
	semaphore.wait()
	return _check_error()

func jump(direction):
	if !direction is String:
		return "WrongDirection"
	if !(direction == "RIGHT" || direction == "LEFT" || direction == "UP"):
		# TODO : display something to the player
		return "WrongWay"
	if !self.player.has_enough_mana(jump_mana_cost):
		# TODO : display somthing to the player
		return "Oom"
	if !self.player.is_on_floor():
		return "NotGrounded"
	jump_scene.setup_jump(direction)
	_change_state(jump_scene)
	semaphore.wait()
	return _check_error()

func teleport(distance:int, direction):
	if !direction is String:
		return "WrongDirection"
	if !self.player.has_enough_mana(teleport_mana_cost):
		# TODO : display somthing to the player
		return "Oom"
	if !self.player.is_on_floor():
		return "NotGrounded"
	_change_state(teleport_scene)
	teleport_scene.setup_teleport(distance, direction)
	semaphore.wait()
	return _check_error()	
	
func _jump_mana_cost(direction: String):
	if (direction == "RIGHT" || direction == "LEFT"):
		return 20
	if direction == "UP":
		return 10
	return null
	
func _check_error():
	var err = Global.errors[error]
	error = Global.CommandError.NONE
	return err

func request_action_cancelled():
	error = Global.CommandError.CANCEL_REQUESTED

# # # # # # # # # # # # # # # # # # # # # # # #

# # # STATE TRANSITIONS # # #
func _change_state(command: Command):
	current_command_mutex.lock()
	current_command.setup_complete = false
	self.current_command = command
	current_command_mutex.unlock()
	
# This function tries to change the state to idle, but aborts if the player thread already owns the
# state mutex.
func lambda_to_idle():
	# If the player thread already owns the mutex, abort.
	if current_command_mutex.try_lock() != OK:
		return
	# Else, we can proceed to the lambda to idle transition
	idle_scene.setup_idle()
	self.current_command = idle_scene
	current_command_mutex.unlock()
	
func to_lambda() -> Command:
	lambda_scene.setup_lambda()
	return lambda_scene

func to_idle() -> Command:
	idle_scene.setup_idle()
	return idle_scene

func to_falling() -> Command:
	fall_scene.setup_fall()
	return fall_scene
	
func to_dashing(direction: float) -> Command:
	dashing_scene.setup_dash(direction)
	return dashing_scene
# # # # # # # # # # # # # # # # # # # # # # # #

# # # PLAYER INPUT FROM GAME # # #

# This actually computes the number of tiles (horizontally) between the player and the next
# body that is in the Layer2
func distance_to_wall(direction):
	var ray_cast: RayCast2D
	if !direction is String:
		return "WrongDirection"
	if direction == "RIGHT":
		ray_cast = $"../RayCastRight"
	elif direction == "LEFT":
		ray_cast = $"../RayCastLeft"
	else:
		return "WrongDirection"
	if !ray_cast.is_colliding():
		return -1
	#warning-ignore:integer_division
	var distance = (int(ray_cast.get_collision_point().distance_to(player.position) + 16)) / 32 - 1
	return distance
	
func on_number():
	return player.number_tile != null

func can_write():
	if on_number():
		return player.number_tile.can_write()
	else:
		return false

func write_number(number):
	if !on_number() or !number is int:
		return false
	else:
		return player.number_tile.write(number)

func read_number():
	if on_number():
		return player.number_tile.read()

# # # # # # # # # # # # # # # # # # # # # # # #


# # # COMMAND ERRORS # # #
func set_error(err):
	self.error = err
	
func task_complete():
	semaphore.post()
	

# # # # # # # # # # # # # # # # # # # # # # # #

