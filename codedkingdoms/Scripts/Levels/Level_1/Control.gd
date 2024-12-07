extends Control

onready var animation_player = $AnimationPlayer
onready var execute_button = get_node("Panel/Execute")
var panel_visible = false


func _ready():
	pass

func _on_Button_pressed():
	if panel_visible:
		animation_player.play("slide_out")
	else:
		animation_player.play("slide_in")
	panel_visible = !panel_visible

func _on_Execute_pressed():
	var text_box = get_node("Panel/TextEdit")
	var code = text_box.text
	var interpreter = get_node("../../")
	interpreter.call("_execute_code", code)


func _on_Reset_pressed():
	var text_box = get_node("Panel/TextEdit")
	text_box.text = ""
	
func disable_execute_button():
	execute_button.disabled = true

func enable_execute_button():
	execute_button.disabled = false
