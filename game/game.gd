extends Node

var settings:PackedScene = load("res://UI/settings_ui.tscn")
var play:PackedScene = load("res://UI/play_ui.tscn")



func _on_play_button_pressed() -> void:
	$UI.visible = false
	$UI.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(play.instantiate())
	


func _on_settings_button_pressed() -> void:
	$UI.visible = false
	$UI.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(settings.instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()
