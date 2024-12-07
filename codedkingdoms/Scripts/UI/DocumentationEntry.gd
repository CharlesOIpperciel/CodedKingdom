extends Panel

var button: Button
var panel_container: PanelContainer
var separator: ColorRect
var tween: Tween
var category_name: Label
var category_description: Label
var subcategories: VBoxContainer

func _ready():
	button = $ExpandToggle
	panel_container = $PanelContainer
	separator = $Separator
	tween = $Tween
	category_name = $CategoryName
	category_description = $PanelContainer/VBoxContainer/CategoryDescription
	subcategories = $PanelContainer/VBoxContainer/VBoxContainer

	panel_container.rect_min_size = Vector2(0, 0)
	panel_container.visible = false
	separator.visible = false
	button.text = "Expand"

	update_panel_size_when_collapsed()

func _on_ExpandToggle_pressed():
	panel_container.visible = !panel_container.visible
	separator.visible = !separator.visible
	if panel_container.visible:
		var _dump = tween.interpolate_property(self, "rect_min_size", Vector2(0, 100), Vector2(0, 200), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		button.text = "Collapse"
		update_panel_size_when_expanded()
	else:
		var _dump = tween.interpolate_property(self, "rect_min_size", Vector2(0, 0), Vector2(0, 100), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		button.text = "Expand"
		update_panel_size_when_collapsed()

func update_panel_size_when_expanded():
	var y_position = category_name.rect_size.y + 15
	
	# Separator position
	separator.rect_position.y = y_position
	y_position += separator.rect_size.y + 10

	# PanelContainer size and position
	panel_container.rect_position.y = y_position
	panel_container.rect_min_size = panel_container.get_minimum_size()
	y_position += panel_container.rect_min_size.y + 10

	# Subcategories size and position
	subcategories.rect_position.y = y_position
	y_position += subcategories.rect_min_size.y

	# Update overall rect size, removing unnecessary bottom margin
	rect_min_size.y = y_position

func update_panel_size_when_collapsed():
	rect_min_size = Vector2(rect_min_size.x, category_name.rect_size.y + 20)

func print_node_hierarchy(node: Node, indent: String = ""):
	print(indent + node.name + " (Height: " + str(node.rect_size.y) + ")")  # For Control nodes

	# Recursively print children
	for child in node.get_children():
		print_node_hierarchy(child, indent + "  ")
