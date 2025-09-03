extends Node

var player_position:Vector2
var set_position:Vector2
var is_scene_changed:bool = false
var can_spawn_map:bool = true
var local:String = "Primeiro Andar"
var enimeis_array:Array[PackedScene]
var return_local:Vector2
var return_scene_path:String
var staris:Vector2

var player_items:Dictionary
var player_life:int


var is_in_menu:bool = true
var is_in_game:bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and is_in_game:
		player.camera.add_child(load("res://UI/menu_ui.tscn").instantiate())
		get_tree().paused = true
		is_in_menu = true
		change_mouse()

func change_mouse():
	if is_in_menu:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/pointer.svg"))
	else:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/sight.png"))
