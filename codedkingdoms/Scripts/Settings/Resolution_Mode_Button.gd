extends Control

onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1280 x 720" : Vector2(1280, 720),
	"1366 x 768" : Vector2(1366, 768),
	"1600 x 900" : Vector2(1600, 900),
	"1920 x 1080" : Vector2(1920, 1080)
}

func _ready():
	var popup_menu = $HBoxContainer/OptionButton.get_popup()
	var flat_style = StyleBoxFlat.new()
	flat_style.bg_color = Color(0.188, 0.275, 0.561)
	popup_menu.add_stylebox_override("panel", flat_style)
	
	option_button.connect("item_selected", self, "_on_resolution_selected")
	add_resolution_items()
	
func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY.keys():
		option_button.add_item(resolution_size_text)
	
func _on_resolution_selected(index: int) -> void:
	var resolution_text = option_button.get_item_text(index)
	var resolution_size = RESOLUTION_DICTIONARY[resolution_text]
	OS.window_size = resolution_size
