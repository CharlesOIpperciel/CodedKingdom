extends Command
class_name Lambda

"""
This state represents a transition to an unknown state.

WHY DO WE NEED THIS:
The character input actions all come from python functions. This means that when an action
completes, there is no way of knowing what the next action is, and thus, it is impossible to
determine which animation the player should play.

An example of a problem caused by that is that if a player does :
move()
move()

The associated player state and animation sequence would be:
WalkingState/Animation
Idle/Animation
WalkingState/Animation

This looks very choppy.

HOW DOES THIS SOLVE THE PROBLEM:
Supposing we run this game on a decent enough computer, 50ms is more than enough for the next
player-input function to choose and execute the appropriate state. This state simply waits 50ms,
and then transitions to Idle, allowing for smoother animation transitions.

POTENTIAL ISSUES AND POTENTIAL SOLUTIONS:
Since this game runs on two threads, one for the input commands, and one(or more?) for the game
engine, we might need to protect the GameManager.current_state with a mutex.
"""

const timeout:float = 0.05 # 50ms
var timeout_elapsed: bool = false
var timer

func _ready():
	timer = Timer.new()
	timer.wait_time = timeout
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)
	
func setup_lambda():
	timeout_elapsed = false
	timer.start()
	
func update(_delta):
	if timeout_elapsed:
		timeout_elapsed = false
		get_node("..").lambda_to_idle()
	
func check_state() -> Command:
	return null

func _on_timeout():
	timeout_elapsed = true
	

