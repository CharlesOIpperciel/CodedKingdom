extends Node

onready var elements = {
	"slider": $"../Panel/SliderGlow",
	"play": $"../Panel/PlayGlow",
	"stop": $"../Panel/StopGlow",
	"reset": $"../Panel/ResetGlow",
	"journal": $Journal,
	"objectives": $Objectives,
	"documentation": $Documentation,
	"minimap": $Minimap,
}

func disable_all():
	for element in elements.values():
		element.visible = false

func toggle_on(element):
	elements[element].visible = true
	
func toggle_off(element):
	elements[element].visible = false
