extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	var settings_ui:CanvasLayer = get_parent().get_child(1)
	settings_ui.visible = true
	settings_ui.process_mode = Node.PROCESS_MODE_INHERIT
	call_deferred("queue_free")
