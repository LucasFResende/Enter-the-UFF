extends Button


@export var id:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var inventoryInterface = get_parent().get_parent().get_parent().get_parent()
	var panel:TextureRect = get_child(1)
	if inventoryInterface.last_button_pressed_id!=-1 and inventoryInterface.last_button_pressed_id!=id-1:
		inventoryInterface.buttons[inventoryInterface.last_button_pressed_id].get_child(1).visible = false
		inventoryInterface.buttons[inventoryInterface.last_button_pressed_id].get_child(1).texture = load("res://addons/ui/panel3.png")
	panel.texture = load("res://addons/ui/panel5.png")
	panel.visible = true
	inventoryInterface.button_pressed_id = id-1
	inventoryInterface.last_button_pressed_id = id-1
