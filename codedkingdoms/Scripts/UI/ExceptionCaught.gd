extends Panel

onready var label = $ErrorMessage
onready var hud = get_node("../..")

func display_text(error_message):
	label.text = error_message
	visible = true

func hide_text():
	visible = false

func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			if get_rect().has_point(event.position):
				hud._on_Error_Reset_pressed()
		elif event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
			hud._on_Error_Reset_pressed()
