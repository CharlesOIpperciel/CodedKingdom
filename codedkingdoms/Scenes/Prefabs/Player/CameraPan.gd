extends Camera2D

export var pan_speed: float = 300.0

func _ready():
	set_process(true)

func _process(delta):
	# Panning is disabled when the editor is out
	if PanelGlobal.panel_visible_global:
		return
	var camera_movement = Vector2()
	
	if Input.is_action_pressed("pan_left"):
		camera_movement.x -= 1
	if Input.is_action_pressed("pan_right"):
		camera_movement.x += 1
	if Input.is_action_pressed("pan_up"):
		camera_movement.y -=1
	if Input.is_action_pressed("pan_down"):
		camera_movement.y += 1

	# Apply the movement to the camera's position
	position += camera_movement.normalized() * pan_speed * delta

	# Reset the camera when the middle mouse button is pressed
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		position = Vector2()
		
