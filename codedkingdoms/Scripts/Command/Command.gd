class_name Command
extends Node

enum Commands {
	IDLE,
	WALKING
}

var player: KinematicBody2D
var setup_complete = false
var sounds

func setup(p):
	self.player = p
	
func setup_sounds(s):
	sounds = s
	
func update(_delta):
	pass
	
func check_state() -> Command:
	return null

func _should_stop() -> bool:
	return get_node("..").error != Global.CommandError.NONE

