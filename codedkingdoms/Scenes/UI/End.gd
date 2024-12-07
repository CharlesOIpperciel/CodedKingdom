extends Label


func _ready():
	$Timer.start()

func _on_Timer_timeout():
	visible = not visible
