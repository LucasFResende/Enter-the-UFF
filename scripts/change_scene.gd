extends CanvasLayer

@onready var anim:AnimationPlayer = %AnimationPlayer

func change_scene(target: String,position:Vector2) -> void:
	anim.play("fade_to_black")
	player.is_moving = false
	player.play_animation()
	await anim.animation_finished
	get_tree().change_scene_to_file(target)
	player.position = position
	GameManager.is_scene_changed = true
	anim.play("fade_away")

func change_label():
	$LocalLabel.text = GameManager.local

func change_player_status(status:bool):
	player.is_scene_changing = status
