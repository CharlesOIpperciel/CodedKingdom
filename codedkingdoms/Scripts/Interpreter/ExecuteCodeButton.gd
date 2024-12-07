extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Execute"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Button_button_up():
	var text_box = get_node("../TextEditor")
	var code = text_box.text
	var interpreter = get_node("../")
	interpreter.call("_execute_code", code)
