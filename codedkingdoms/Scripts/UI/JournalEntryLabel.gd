extends Panel

func _ready():
	update_panel_size()

func update_panel_size():
	$VBoxContainer/Label.rect_min_size = Vector2(0, 0)
	$VBoxContainer/Label.rect_min_size = $VBoxContainer/Label.get_minimum_size()
	rect_min_size = Vector2(rect_min_size.x, $VBoxContainer/Label.rect_min_size.y + 20)


func _on_JournalEntryContainer_mouse_entered():
	$VBoxContainer/Label.add_color_override("font_color", Color(0.55, 0.55, 0.55))
