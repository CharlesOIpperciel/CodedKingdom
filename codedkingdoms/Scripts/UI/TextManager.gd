extends Node

var text_data_path = "res://Assets/Text/GrandWizardDialog.json"
var text_data
onready var journal = get_node("../HUD")
onready var conversation_box = $ConversationBox
var current_level

func _ready():
	text_data = _load_json(text_data_path)
	conversation_box.connect("dialog_complete", self, "_dialog_complete")
	conversation_box.add_icon("GrandWizard")
	
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

func set_level(level):
	current_level = level

func start_dialog(level, index):
	conversation_box.visible = true
	var dialogs = text_data[level][index]
	for dialog in dialogs:
		conversation_box.queue_text(dialog)
		journal.add_dialog_entry(dialog)
	conversation_box.read_dialog()

func _dialog_complete():
	conversation_box.visible = false
	current_level.dialog_complete()
