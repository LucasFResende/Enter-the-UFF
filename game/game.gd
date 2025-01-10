extends Node

var solo:String = "res://map/uff_floor1.tscn"
var settings:String = "res://UI/settings_ui.tscn"



func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(solo)
	GameManager.is_in_menu = false
	GameManager.change_mouse()


func _on_settings_button_pressed() -> void:
	$UI.visible = false
	$UI.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(load(settings).instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()
