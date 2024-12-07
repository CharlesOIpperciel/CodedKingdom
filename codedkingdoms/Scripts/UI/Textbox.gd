extends CanvasLayer

const READ_RATE = 0.05

onready var textboxContainer = $TextboxContainer
onready var startSymbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
onready var endSymbol = $TextboxContainer/MarginContainer/HBoxContainer/End
onready var text = $TextboxContainer/MarginContainer/HBoxContainer/Text

enum State {
	INIT,
	READY,
	READING,
	FINISHED
}

var currentState = State.INIT
var textQueue = []
var clicked = false
signal dialog_complete

func _process(_delta):
	match currentState:
		State.READY:
			if !textQueue.empty():
				display_text()
			else:
				change_state(State.INIT)
				hide_textbox()
				emit_signal("dialog_complete")
		State.READING:
			if clicked:
				clicked = false
				text.percent_visible = 1.0
				$Tween.remove_all()
				endSymbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if clicked:
				clicked = false
				change_state(State.READY)
				clear_textbox()

func hide_textbox():
	textboxContainer.hide()
	
func clear_textbox():
	startSymbol.text	= ""
	endSymbol.text = ""
	text.text = ""
	
func show_textbox():
	startSymbol.text	= "*"
	textboxContainer.show()

func queue_text(add_text):
	textQueue.push_back(add_text)
	
func read_dialog():
	change_state(State.READY)
	
func display_text():
	var add_text = textQueue.pop_front()
	text.text = add_text
	text.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(add_text) * READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	endSymbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	currentState = next_state

func add_icon(name):
	var icon = $TextboxContainer/MarginContainer/PanelIcon/Speaker
	var icon_path = ""
	match name:
		"GrandWizard":
			icon_path = "res://Assets/Player/GrandWizard.png"
	
	var texture = load(icon_path)
	if texture:
		icon.texture = texture
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	else:
		print("Error: Failed to load texture for speaker: " + name)
