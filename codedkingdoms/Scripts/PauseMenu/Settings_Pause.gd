class_name Settings_Pause
extends Control

# Getter for the buttons
onready var back_button = $"Back button" as TextureButton

# Redirect to the correct pages
func _ready():
	handle_connecting_signals()
	
func _on_back_button_pressed() -> void:
	$ClickSound.play()
	yield($ClickSound, "finished")
	$".".hide()
	$"../..".show()
	
	
func handle_connecting_signals() -> void:
	back_button.connect("pressed", self, "_on_back_button_pressed")
