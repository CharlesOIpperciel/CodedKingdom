class_name Settings_Tab_Container
extends Control

# Getter for the buttons
onready var back_button = $"Back button" as TextureButton

# Getter for the other scenes
var main_menu_scene = load("res://Scenes/MainMenu/Main_menu.tscn")

# Redirect to the correct pages
func _ready():
	handle_connecting_signals()
	
func _on_back_button_pressed() -> void:
	$ClickSound.play()
	yield($ClickSound, "finished")
	var _dump = SceneTransition.change_scene(main_menu_scene)
	
	
func handle_connecting_signals() -> void:
	back_button.connect("pressed", self, "_on_back_button_pressed")
