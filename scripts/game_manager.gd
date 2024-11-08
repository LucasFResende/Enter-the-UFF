extends Node

var player_position:Vector2
var set_position:Vector2
var is_scene_changed:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
