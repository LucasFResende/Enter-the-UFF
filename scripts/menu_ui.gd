extends CanvasLayer

var settings:PackedScene = load("res://UI/in_game_settings_ui.tscn")

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	GameManager.is_in_menu = false
	GameManager.change_mouse()
	call_deferred("queue_free")


func _on_quit_main_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	get_parent().add_child(settings.instantiate())
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
