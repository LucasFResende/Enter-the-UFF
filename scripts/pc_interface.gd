extends CanvasLayer

func _add_child(path:String):
	add_child(load(path).instantiate())
