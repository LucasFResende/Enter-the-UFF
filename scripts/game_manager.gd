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
var player_actual_ammo:int
var player_bag_ammo:int

var is_in_menu:bool = true
var is_in_game:bool = false

var player_custom_hair:Color = Color(0, 0, 0)
var player_custom_shirt:Color = Color(0.067, 0.067, 0.075)
var player_custom_emblem:Color = Color(0.416, 0.745, 0.188)
var player_custom_short:Color = Color(0.224, 0.31, 0.471)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and is_in_game:
		get_tree().paused = true

func change_mouse():
	if is_in_menu:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/pointer.svg"))
	else:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/sight.png"))
