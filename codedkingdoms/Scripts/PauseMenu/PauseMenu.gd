extends Control

onready var main_menu_scene = load("res://Scenes/MainMenu/Main_menu.tscn") as PackedScene
onready var pause_game_scene = load("res://Scenes/Pause/Settings_Pause.tscn") as PackedScene
onready var colorRect = $ColorRect

func _ready():
	$".".hide()
	colorRect.hide()
	$CanvasLayer/Settings_Pause.hide()
	
func testEsc():
	if Input.is_action_just_pressed("ui_cancel"):
		if $CanvasLayer/Settings_Pause.visible:
			# If settings menu is open, close it, but keep the game paused
			$CanvasLayer/Settings_Pause.hide()
			$".".show()
		elif get_tree().paused:
			# If the game is paused and settings menu is not open, unpause the game
			$".".hide()
			colorRect.hide()
			get_tree().paused = false
		else:
			# If the game is not paused, show the pause menu and pause the game
			$".".show()
			colorRect.show()
			get_tree().paused = true

func _on_Resume_pressed():
	$ClickSound.play()
	yield($ClickSound, "finished")
	get_tree().paused = false
	$".".hide()
	colorRect.hide()

func _on_Settings_pressed():
	$ClickSound.play()
	yield($ClickSound, "finished")
	$".".hide()
	$CanvasLayer/Settings_Pause.show()

func _on_Exit_pressed():
	$ClickSound.play()
	yield($ClickSound, "finished")
	get_tree().paused = false
	var _dump = get_tree().change_scene_to(main_menu_scene)

func _process(_delta):
	testEsc()
