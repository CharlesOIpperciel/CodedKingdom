extends Node

onready var jump_sounds =  [
	$Jump1,
	$Jump2,
	$Jump3,
	$Jump4,
	$Jump5,
	$Jump6,
	$Jump7,
]

onready var footstep_sounds = [
	$Footstep1,
	$Footstep2,
	$Footstep3,
	$Footstep4,
	$Footstep5,
	$Footstep6,
	$Footstep7,
]

onready var death_sounds = [
	$Death1,
	$Death2,
	$Death3,
	$Death4,
] 

onready var sounds = {
	"death": death_sounds,
	"foot_step": footstep_sounds,
	"jump": jump_sounds,
}

func play_random_sound(type_of_sound: String):
	if !sounds.has(type_of_sound):
		return
	var requested_sounds = sounds[type_of_sound]
	if requested_sounds.size() == 0:
		return
	var random_index = randi() % requested_sounds.size()
	var sound = requested_sounds[random_index]
	if sound.is_playing():
		sound.stop()
	sound.play()
