extends CanvasLayer

var control:PackedScene = load("res://UI/control_ui.tscn")

func _on_control_button_pressed() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	add_sibling(control.instantiate())


func _on_back_button_pressed() -> void:
	var ui:CanvasLayer = get_parent().get_child(0)
	ui.visible = true
	ui.process_mode = Node.PROCESS_MODE_INHERIT
	call_deferred("queue_free")
