extends Node

var have_to_change:bool = false
var changing:bool = false
var action_name:String
var button_icon_change:Controls

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		changing = false
	if event is InputEventKey and changing:
		make_change(event,action_name)
		changing = false

func change_input(action:String,button:Controls):
	changing = true
	action_name = action
	button_icon_change = button
	
func make_change(event_key:InputEventKey,action_name:String):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name,event_key)
	have_to_change = true
	button_icon_change.update_icon()
