extends Node

var lvl_1 = preload("res://Scenes/Levels/Level1/Level1.tscn")
var lvl_2 = preload("res://Scenes/Levels/Level2/Level2.tscn")
var lvl_3 = preload("res://Scenes/Levels/Level3/Level3.tscn")
var lvl_4 = preload("res://Scenes/Levels/Level4/Level4.tscn")
var lvl_5 = preload("res://Scenes/Levels/Level5/Level5.tscn")
var lvl_6 = preload("res://Scenes/Levels/Level6/Level6.tscn")
var lvl_7 = preload("res://Scenes/Levels/Level7/Level7.tscn")
var lvl_8 = preload("res://Scenes/Levels/Level8/Level8.tscn")
var credit_scene = preload("res://Scenes/Credits/CreditScene.tscn")

var levels = [lvl_1, lvl_2, lvl_3, lvl_4, lvl_5, lvl_6, lvl_7, lvl_8, credit_scene]
var camera_lmits
var current_level: Node
var current_level_index = 0
var use_popup = false
onready var level_popup = $LevelPopup
onready var level_input = $LevelPopup/LevelInput
onready var confirm_button = $LevelPopup/ConfirmButton
onready var text_manager = $TextManager
onready var minimap = $HUD/CanvasLayer/Minimap
onready var grid = $HUD/CanvasLayer/Minimap/MarginContainer/Grid

var gridOn = false

onready var volume_tween = $VolumeTween

func _ready():
	InGameThemeMusic1.play()
	_start_music_with_fade()
	if use_popup:
		level_popup.popup_centered()
		confirm_button.connect("pressed", self, "_on_confirm_button_pressed")
	else:
		setup(0)

func _start_music_with_fade():
	InGameThemeMusic1.volume_db = -80
	InGameThemeMusic1.play()
	volume_tween.interpolate_property(
		InGameThemeMusic1,
		"volume_db",
		-80,
		-40,
		3.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	volume_tween.start()

func _on_confirm_button_pressed() -> void:
	var level_index = level_input.text.to_int()
	if level_index >= 0 and level_index < levels.size():
		level_popup.hide()
		setup(level_index)
	else:
		print("Invalid level index entered.")
	
func setup(index):
	current_level_index = index
	current_level = levels[current_level_index].instance()
	text_manager.set_level(current_level)

	var base_level = current_level.get_node("BaseLevel") 
	if base_level != null:
		var player = base_level.get_node("Player")
		if player != null:
			minimap._setPlayer(player)
	add_child(current_level)

func level_complete():
	current_level_index += 1
	if current_level_index == levels.size() - 1:
		_play_credits()
		return
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.leave_group()
	for player in get_tree().get_nodes_in_group("player"):
		player.leave_group()
	for interpreter in get_tree().get_nodes_in_group("interpreter"):
		interpreter.leave_group()
	var next_level = levels[current_level_index].instance()
	var previous_level = current_level
	current_level = next_level
	text_manager.set_level(current_level)
	var base_level = current_level.get_node("BaseLevel") 
	if base_level != null:
		var player = base_level.get_node("Player")
		if player != null:
			minimap._setPlayer(player)
	removeCheckpointMarkers()
	
	yield(SceneTransition.change_scene(current_level), "completed")
	
	add_child(current_level)
	previous_level.queue_free()

func _play_credits():
	$HUD.visible = false
	var next_level = levels[current_level_index].instance()
	current_level = next_level
	for child in get_children():
		child.queue_free()
	yield(SceneTransition.change_scene(current_level), "completed")
	add_child(current_level)
	
func reset_current_level():
	current_level.master_reset()

func removeCheckpointMarkers():
	for child in grid.get_children():
		if child is Sprite and child.name != "CheckpointMarkerOriginal" and child.name != "Playermarker":
			child.queue_free()

func toggle_grid():
	var map_node = current_level.get_node("Map")
	if map_node:
		var background = map_node.get_node("Castle")
		if background and background.material:
			var shader_material = background.material
			if shader_material is ShaderMaterial:
				var current_state = shader_material.get_shader_param("draw_grid")
				shader_material.set_shader_param("draw_grid", !current_state)
				gridOn = !current_state
