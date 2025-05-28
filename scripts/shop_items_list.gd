extends Node

var items: Array

func _ready() -> void:
	var file = FileAccess.open("res://shop items/items.json",FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	items = JSON.parse_string(json_text)
