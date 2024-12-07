class_name MainMenu
extends Control

# Getter for the buttons
onready var start_button = $"MarginContainer/HBoxContainer/VBoxContainer/Start Button" as TextureButton
onready var settings_button = $"MarginContainer/HBoxContainer/VBoxContainer/Settings Button" as TextureButton
onready var exit_button = $"MarginContainer/HBoxContainer/VBoxContainer/Exit Button" as TextureButton

# Getter for the other scenes
var level_loader = preload("res://Scenes/Levels/LevelLoader.tscn")
var settings_scene = preload("res://Scenes/Settings/Settings.tscn")

onready var volume_tween = $VolumeTween

# Redirect to the function thats connects all the buttons to their signals
func _ready():
	handle_connecting_signals()
	
func _on_start_button_pressed() -> void:
	$ClickSound.play()
	yield($ClickSound, "finished")
	_fade_out_music(MainThemeMusic, 1.0)
	yield(volume_tween, "tween_all_completed")
	var _dump = SceneTransition.change_scene(level_loader)

func _on_settings_button_pressed() -> void:
	$ClickSound.play()
	yield($ClickSound, "finished")
	var _dump = SceneTransition.change_scene(settings_scene)

func _on_exit_button_pressed() -> void:
	$ClickSound.play()
	yield($ClickSound, "finished")
	get_tree().quit()

func handle_connecting_signals() -> void:
	start_button.connect("pressed", self, "_on_start_button_pressed")
	settings_button.connect("pressed", self, "_on_settings_button_pressed")
	exit_button.connect("pressed", self, "_on_exit_button_pressed")
	
func _fade_out_music(audio_player: AudioStreamPlayer, duration: float) -> void:
	volume_tween.interpolate_property(
		audio_player,
		"volume_db",
		audio_player.volume_db,
		-80,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	volume_tween.start()
