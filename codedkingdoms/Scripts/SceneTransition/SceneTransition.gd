extends CanvasLayer

func change_scene(target) -> void:
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, 'animation_finished')
	
	if target is PackedScene:
		var scene_instance = target.instance()
		get_tree().root.add_child(scene_instance)
		get_tree().current_scene.free()
		get_tree().current_scene = scene_instance
	elif target is String:
		var _dump = get_tree().change_scene(target)
	
	$AnimationPlayer.play_backwards("dissolve")


