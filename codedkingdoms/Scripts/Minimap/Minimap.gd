extends MarginContainer

var player
var checkpoints
var playerRealMarkerPos

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/Playermarker
onready var checkpoint_marker = $MarginContainer/Grid/CheckpointMarkerOriginal
onready var pan_left_button = $MarginContainer/Grid/PanLeftButton
onready var pan_right_button = $MarginContainer/Grid/PanRightButton
onready var pan_up_button = $MarginContainer/Grid/PanUpButton
onready var pan_down_button = $MarginContainer/Grid/PanDownButton

var minimap_scale = 0.5  
var fixed_playerMarker_position = Vector2(17, 96)
var initial_playerMarker_position = Vector2(17, 96)
var initial_checkpoint_position = Vector2(17, 96)

onready var pan_speed = 30
var content_offset = Vector2(0, 0)

var minimap_width = 1000
var minimap_height = 1000 

var last_player_position = Vector2()

func _process(_delta):
	if player != null:
		updatePlayerMarker()
	check_pan_button_states()

func _setPlayer(p):
	initial_playerMarker_position = fixed_playerMarker_position
	player = p
	if player != null:
		last_player_position = player.position
		updatePlayerMarker()

func _setCheckpoints(cp):
	checkpoints = cp
	addCheckpointMarkers()

func _setPlayerRealMarkerPos(r):
	playerRealMarkerPos = r

func updatePlayerMarker():
	# Only check for auto pan if the player position has changed
	if player != null:
		var player_position = player.position
		var scaled_position = player_position * minimap_scale
		var marker_position = initial_playerMarker_position + scaled_position
		
		player_marker.position = marker_position
		player_marker.visible = is_position_in_grid(marker_position)
		
		if player_position.x < last_player_position.x:
			player_marker.flip_h = true 
		elif player_position.x > last_player_position.x:
			player_marker.flip_h = false 
		
		last_player_position = player_position
	else:
		print("Player is null, unable to update marker position.")


func addCheckpointMarkers():
	for checkpoint in checkpoints:
		if checkpoint is Node2D:
			var checkpoint_position = checkpoint.global_position
			var scaled_position = checkpoint_position * minimap_scale
			var new_checkpoint_marker = checkpoint_marker.duplicate()
			new_checkpoint_marker.name = "checkpointmarker"
			new_checkpoint_marker.position = initial_checkpoint_position + scaled_position
			grid.add_child(new_checkpoint_marker)
			new_checkpoint_marker.show()

func _on_PanLeftButton_pressed():
	content_offset.x += pan_speed
	update_grid_content_position()

func _on_PanRightButton_pressed():
	content_offset.x -= pan_speed
	update_grid_content_position()

func _on_PanUpButton_pressed():
	content_offset.y += pan_speed
	update_grid_content_position()
	
func _on_PanDownButton_pressed():
	content_offset.y -= pan_speed
	update_grid_content_position()

func update_grid_content_position():
	for child in grid.get_children():
		if child is Node2D and not child.name.begins_with("Pan") and not child.name.begins_with("CheckpointMarkerOriginal"):
			child.position.x += content_offset.x
			child.position.y += content_offset.y
			child.visible = is_position_in_grid(child.position)
	initial_playerMarker_position.x += content_offset.x
	initial_playerMarker_position.y += content_offset.y
	updatePlayerMarker()
	content_offset = Vector2(0, 0)

func is_position_in_grid(position: Vector2) -> bool:
	return position.x >= 0 and position.x <= 231 and position.y >= 0 and position.y <= 116

func updatePlayerMarkerOffset():
	initial_playerMarker_position.x += content_offset.x

func check_pan_button_states():
	pan_left_button.disabled = initial_playerMarker_position.x > 16
	pan_down_button.disabled = initial_playerMarker_position.y < 97
