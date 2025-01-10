extends CanvasLayer

var control_path:String = "res://UI/in_game_control_ui.tscn"

func _on_control_button_pressed() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	add_sibling(load(control_path).instantiate())


func _on_back_button_pressed() -> void:
	var ui:CanvasLayer = get_parent().get_child(3)
	ui.visible = true
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("queue_free")
