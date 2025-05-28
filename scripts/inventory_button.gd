extends Button


@export var id:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var Interface = get_parent().get_parent().get_parent().get_parent()
	var panel:TextureRect = get_child(1)
	panel.texture = load("res://addons/ui/panel5.png")
	panel.visible = true
	Interface.button_pressed_id = id-1
	Interface.buttons[Interface.last_button_pressed_id].get_child(1).visible = false
	Interface.last_button_pressed_id = id-1
