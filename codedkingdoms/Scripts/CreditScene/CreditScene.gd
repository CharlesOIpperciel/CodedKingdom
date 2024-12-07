extends Control

onready var credits_label = $Label
onready var tween = $VolumeTween
var speed = 30
var main_menu = load("res://Scenes/MainMenu/Main_menu.tscn")

func _ready():
	transition_music()

func _process(delta):
	if credits_label.rect_position.y > -900:
		credits_label.rect_position.y -= delta * speed

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		return_to_main_menu()

func transition_music():
	tween.interpolate_property(
		InGameThemeMusic1,
		"volume_db",
		InGameThemeMusic1.volume_db,
		-80,
		3.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	CreditTheme.volume_db = -80
	CreditTheme.play()
	tween.interpolate_property(
		CreditTheme,
		"volume_db",
		-80,
		-40,
		3.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	tween.start()

func return_to_main_menu():
	tween.interpolate_property(
		CreditTheme,
		"volume_db",
		CreditTheme.volume_db,
		-80,
		3.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	MainThemeMusic.volume_db = -80
	MainThemeMusic.play()
	tween.interpolate_property(
		MainThemeMusic,
		"volume_db",
		-80,
		-40,
		3.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	tween.start()
	yield(tween, "tween_completed")
	get_tree().change_scene_to(main_menu)
