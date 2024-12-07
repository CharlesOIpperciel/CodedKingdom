extends Node

class_name Challenge

# Declare member variables here. Examples:
var challenge_name: String
var challenge_description: String
# Validation is input : expected_output test collection.
var validation: Dictionary
var interactable: bool
var challenge_in_progress: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable = false
	challenge_in_progress = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enter_challenge = Input.is_action_just_released("enter_challenge")
	if enter_challenge && interactable && !challenge_in_progress:
		enter_challenge()

func _on_ChallengeBox_body_entered(body):
	#display the popup
	print("collided")
	$ChallengeBox/ChallengePopUpSprite.visible = true
	#set this to be interactable (press e to start challenge or whatever)
	interactable = true
	pass # Replace with function body.


func _on_ChallengeBox_body_exited(body):
	#hide the popup
	#set this to be non interactable (press e to start challenge or whatever)	
	interactable = false;
	$ChallengeBox/ChallengePopUpSprite.visible = false
	pass # Replace with function body.
	
func enter_challenge():
	print("enter_challenge")
	challenge_in_progress = true
	
