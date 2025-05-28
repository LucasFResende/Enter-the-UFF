extends CanvasLayer

var play:String = "res://map/uff_floor1.tscn"
var customize:PackedScene = load("res://UI/player_customizer.tscn")


func _on_back_button_pressed() -> void:
	var ui:CanvasLayer = get_parent().get_child(0)
	ui.visible = true
	ui.process_mode = Node.PROCESS_MODE_INHERIT
	player.hair_color = Color("000000")
	player.shirt_color = Color("111113")
	player.emblem_color = Color("6abe30")
	player.short_color = Color("394f78")
	call_deferred("queue_free")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(play)
	GameManager.is_in_menu = false
	GameManager.change_mouse()
	player.active()
	player.position = Vector2(12,50)
	


func _on_custom_button_pressed() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	add_sibling(customize.instantiate())
