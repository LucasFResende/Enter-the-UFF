class_name Controls
extends Button

@export var action_name:String

func _ready() -> void:
	update_icon()

func _on_pressed() -> void:
	ChangeControls.change_input(action_name,self)

func update_icon():
	var key_label:String = InputMap.action_get_events(action_name)[0].as_text().to_lower().replace(" (physical)","").replace("kp ","")
	icon = load("res://addons/input_keys/Keyboard & Mouse/keyboard_"+ key_label +"_outline.svg")
