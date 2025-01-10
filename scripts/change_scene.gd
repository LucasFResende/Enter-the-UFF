extends CanvasLayer

func change_scene(target: String,position:Vector2) -> void:
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	GameManager.set_position = position
	GameManager.is_scene_changed = true

func change_label():
	$LocalLabel.text = GameManager.local
