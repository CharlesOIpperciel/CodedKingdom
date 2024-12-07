extends Control

onready var option_button = $HBoxContainer/OptionButton as OptionButton

const WINDOW_MODE_ARRAY : Array = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]

func _ready():
	var popup_menu = $HBoxContainer/OptionButton.get_popup()
	var flat_style = StyleBoxFlat.new()
	flat_style.bg_color = Color(0.188, 0.275, 0.561)
	popup_menu.add_stylebox_override("panel", flat_style)
	
	add_window_mode_items()
	option_button.connect("item_selected", self, "_on_window_mode_selected")

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)

func _on_window_mode_selected(index: int) -> void:
	match index:
		0: # Full-Screen
			OS.window_fullscreen = true
			OS.window_borderless = false
		1: # Window Mode
			OS.window_fullscreen = false
			OS.window_borderless = false
		2: # Borderless Window
			OS.window_fullscreen = false
			OS.window_borderless = true
		3: # Borderless Full-Screen
			OS.window_fullscreen = true
			OS.window_borderless = true
