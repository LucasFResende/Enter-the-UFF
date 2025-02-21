extends CanvasLayer

func change_scene(target: String,position:Vector2) -> void:
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	var tree = get_parent().get_parent().get_parent()
	tree.get_child(9).queue_free()
	tree.add_child(load(target).instantiate())
	player.position = position
	GameManager.is_scene_changed = true
	$AnimationPlayer.play("fade_away")

func change_label():
	$LocalLabel.text = GameManager.local
