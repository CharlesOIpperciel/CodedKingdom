extends Control

func _ready():
	MainThemeMusic.play()
	$AnimatedSprite.play("show_logo")
	$Timer.start()

func _on_Timer_timeout():
	var _dump = get_tree().change_scene("res://Scenes/MainMenu/Main_menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel") or event is InputEventMouseButton:
		$AnimatedSprite.stop()
		_on_Timer_timeout()
