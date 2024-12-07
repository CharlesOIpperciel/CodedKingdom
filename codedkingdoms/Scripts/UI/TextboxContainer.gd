extends MarginContainer

func _input(event):
	if not PanelGlobal.panel_visible_global:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(event.position):
				get_node("..").clicked = true
		elif event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
			get_node("..").clicked = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(event.position):
				get_node("..").clicked = true
