extends Control

# Texture Buttons and resources can stay as they are.
onready var execute_button = $CanvasLayer/Panel/Execute as TextureButton
onready var slide_out_png = preload("res://Assets/GameUI/Editor/SliderBackward.png")
onready var slide_in_png = preload("res://Assets/GameUI/Editor/SliderNormal.png")
onready var slide_button = $CanvasLayer/Panel/Slide as TextureButton
onready var stop_button = $CanvasLayer/Panel/Stop as TextureButton
onready var exception_panel = $CanvasLayer/ExceptionCaught

onready var minimap = $CanvasLayer/Minimap
onready var validation = $CanvasLayer/Panel/Validation
onready var mana_bar = $CanvasLayer/ManaBar
onready var journal = $CanvasLayer/Journal
onready var tutorial_glow = $CanvasLayer/TutorialGlow

var dialog_entries = []
var panel_visible = false

var journal_documentation_path = "res://Assets/Text/JournalDocumentation.json"
var journal_documentation
var dialog_entry_counter = 1

var objectives_path = "res://Assets/Text/JournalObjectives.json"
var objectives
var objective_entry_counter = 1

var level_loader_scene = load("res://Scenes/Levels/LevelLoader.tscn")
var level_loader

onready var sounds = $"../Sounds"

func _ready():
	level_loader = get_parent()
	journal_documentation = _load_json(journal_documentation_path)
	objectives = _load_json(objectives_path)
	
	populate_documentation()
	
	if journal && minimap:
		journal.visible = false
		minimap.visible = false
		
	disable_stop_button()

func _on_Execute_pressed():
	slide_out_panel_before_executing()
	#execute code is called in func _when_Panel_is_Slid_In() after the timer is done

func _on_Slide_pressed():
	if panel_visible and PanelGlobal.panel_visible_global:
		slide_button.texture_normal = slide_in_png
		$AnimationPlayer.play("slide_panel_out_the_game")
	else:
		slide_button.texture_normal = slide_out_png
		$AnimationPlayer.play("slide_panel_in_the_game")

	panel_visible = !panel_visible
	PanelGlobal.panel_visible_global = !PanelGlobal.panel_visible_global

func reset_text():
	var text_box = $CanvasLayer/Panel/TextEdit
	text_box.text = ""

func _on_Reset_pressed():
	validation.visible = true

func slide_out_panel_before_executing():
	_on_Slide_pressed()
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5  # Adjust this time if necessary for the slide duration
	timer.connect("timeout", self, "_when_Panel_is_Slid_In")
	add_child(timer)
	timer.start()

func _when_Panel_is_Slid_In():
	var text_box = $CanvasLayer/Panel/TextEdit
	var code = text_box.text
	if code.length() == 0:
		return
	get_parent().current_level.player.center_camera_on_player()
	var interpreter = get_tree().get_nodes_in_group("interpreter")[0]
	interpreter.call("_execute_code", code)

# UI Toggle Helpers
func disable_execute_button():
	if execute_button:
		execute_button.disabled = true

func enable_execute_button():
	if execute_button:
		execute_button.disabled = false

func disable_stop_button():
	if stop_button:
		stop_button.disabled = true

func enable_stop_button():
	if stop_button:
		stop_button.disabled = false

# Handle stopping the game or process
func _on_Stop_pressed():
	get_tree().get_nodes_in_group("player")[0].get_node("CommandManager").request_action_cancelled()

# Dialog Handling
func add_dialog_entry(entry: String) -> void:
	var entry_container = $CanvasLayer/Journal/TabContainer/Dialogs/DialogEntries
	var custom_label_scene = preload("res://Scenes/Prefabs/JournalEntryLabel.tscn")
	
	var container = custom_label_scene.instance()
	var journal_label = container.get_node("VBoxContainer/Label")
	journal_label.text = str(dialog_entry_counter) + "- " + entry
	entry_container.add_child(container)
	entry_container.move_child(container, 0)
	
	dialog_entry_counter += 1

func add_objective_entry(level: String, checkpoint: String) -> void:
	var entry_container = $CanvasLayer/Journal/TabContainer/Objectives/ObjectiveEntries
	var custom_label_scene = preload("res://Scenes/Prefabs/ObjectiveEntryLabel.tscn")
	
	var container = custom_label_scene.instance()
	var objective = container.get_node("VBoxContainer/Label")
	objective.text = str(objective_entry_counter) + "- " + objectives[level][checkpoint]
	entry_container.add_child(container)
	entry_container.move_child(container, 0)
	
	objective_entry_counter += 1

func mark_objective_as_complete() -> void:
	var entry_container = $CanvasLayer/Journal/TabContainer/Objectives/ObjectiveEntries
	entry_container.get_child(0).mark_as_complete()

func populate_documentation() -> void:
	var documentation_panel = $CanvasLayer/Journal/TabContainer/Documentation/DocumentationEntries
	var documentation_entry_scene = preload("res://Scenes/Prefabs/DocumentationEntry.tscn")
	var documentation_subentry_scene = preload("res://Scenes/Prefabs/DocumentationSubEntry.tscn")
	
	for entry in journal_documentation:
		var container = documentation_entry_scene.instance()
		
		var documentation_category_name = container.get_node("CategoryName")
		documentation_category_name.text = journal_documentation[entry]["name"]
		
		var documentation_category_description = container.get_node("PanelContainer/VBoxContainer/CategoryDescription")
		documentation_category_description.text = journal_documentation[entry]["description"]
		
		for sub_entry in journal_documentation[entry]["listing"]:
			var subcontainer = documentation_subentry_scene.instance()

			var documentation_subcategory_description = subcontainer.get_node("MarginContainer/VBoxContainer/SubCategoryDescription")
			documentation_subcategory_description.text = journal_documentation[entry]["listing"][sub_entry]["description"]

			if journal_documentation[entry]["listing"][sub_entry].has("snippet"):
				var documentation_subcategory_snippet = subcontainer.get_node("MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Snippets")
				for line in journal_documentation[entry]["listing"][sub_entry]["snippet"]:
					var rich_text_label = RichTextLabel.new()
					rich_text_label.bbcode_enabled = true
					
					var processed_line = process_line_for_gray_text(line)
					
					rich_text_label.bbcode_text = processed_line
					rich_text_label.margin_bottom = 0
					rich_text_label.margin_top = 0
					
					rich_text_label.rect_min_size = Vector2(0, 20)

					documentation_subcategory_snippet.add_child(rich_text_label)

			container.get_node("PanelContainer/VBoxContainer/VBoxContainer").add_child(subcontainer)
		
		documentation_panel.add_child(container)

func process_line_for_gray_text(line: String) -> String:
	var hash_index = line.find("#")
	
	if hash_index != -1:
		var before_hash = line.substr(0, hash_index)
		var after_hash = line.substr(hash_index, line.length())
		return before_hash + "[color=#FF69B4]" + after_hash + "[/color]"
	else:
		return line

func display_exception(error_message):
	play_death_sound()
	exception_panel.display_text(error_message)

func _on_JournalToggle_pressed():
	journal.visible = !journal.visible

func _on_Error_Reset_pressed():
	exception_panel.hide_text()
	get_tree().get_nodes_in_group("player")[0].reset_to_last_checkpoint()
	disable_stop_button()
	enable_execute_button()
	get_parent().reset_current_level()

func _load_json(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		var json_string = file.get_as_text()
		file.close()
		
		var result = JSON.parse(json_string)
		
		if result.error != null:
			return result.result
		else:
			print("Cannot parse JSON: ", path)
			return null
	else:
		print("Cannot find file: ", path)
		return null

func play_death_sound():
	sounds.play_random_sound("death")


func _on_MinimapToggle_pressed():
	if minimap.visible:
		minimap.visible = false
	else:
		minimap.visible = true

func _on_Ok_pressed():
	reset_text()
	validation.visible = false

func _on_Cancel_pressed():
	validation.visible = false

func set_maximum_mana(mana):
	mana_bar.max_value = mana
	mana_bar.value = mana

func spend_mana(mana):
	mana_bar.value = max(mana_bar.value - mana, 0)

func tutorial_connect_signals(target):
	var _dump = slide_button.connect("pressed", target, "_on_slider_pressed")
	_dump = stop_button.connect("pressed", target, "_on_stop_pressed")
	_dump = $CanvasLayer/Panel/Execute.connect("pressed", target, "_on_execute_pressed")
	_dump = $CanvasLayer/Panel/Reset.connect("pressed", target, "_on_reset_pressed")
	_dump = $CanvasLayer/JournalToggle.connect("pressed", target, "_on_journal_pressed")
	_dump = $CanvasLayer/MinimapToggle.connect("pressed", target, "_on_minimap_pressed")

func tutorial_disconnect_signals(target):
	slide_button.disconnect("pressed", target, "_on_slider_pressed")
	stop_button.disconnect("pressed", target, "_on_stop_pressed")
	$CanvasLayer/Panel/Execute.disconnect("pressed", target, "_on_execute_pressed")
	$CanvasLayer/Panel/Reset.disconnect("pressed", target, "_on_reset_pressed")
	$CanvasLayer/JournalToggle.disconnect("pressed", target, "_on_journal_pressed")
	$CanvasLayer/MinimapToggle.disconnect("pressed", target, "_on_minimap_pressed")

func disable_all_tutorial_glow():
	tutorial_glow.disable_all()

func _on_GridToggle_pressed():
	level_loader.toggle_grid()
