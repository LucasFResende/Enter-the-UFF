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

var player_custom_hair:Color = Color(0, 0, 0)
var player_custom_shirt:Color = Color(0.067, 0.067, 0.075)
var player_custom_emblem:Color = Color(0.416, 0.745, 0.188)
var player_custom_short:Color = Color(0.224, 0.31, 0.471)

var guns:Array[PackedScene] = [load("res://guns/ar.tscn"),load("res://guns/ar_halo.tscn"),
load("res://guns/aug.tscn"),load("res://guns/barret.tscn"),load("res://guns/deagle.tscn"),
load("res://guns/machine_pistol.tscn"),load("res://guns/nerf.tscn"),load("res://guns/pistol.tscn"),
load("res://guns/plasma_pistol.tscn"),load("res://guns/pump_shotgun.tscn"),load("res://guns/revolver.tscn"),
load("res://guns/rocket_launcher.tscn"),load("res://guns/shotgun.tscn"),load("res://guns/sniper.tscn"),
load("res://guns/lightsaber_blue.tscn"),load("res://guns/flamethrower.tscn")]

var player_gun:PackedScene
var player_actual_gun:Gun

var gun_actual_ammo:int
var gun_bag_ammo:int

func _ready() -> void:
	player_gun = guns.pick_random()
	player_actual_gun = player_gun.instantiate()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and is_in_game:
		get_tree().paused = true

func change_mouse():
	if is_in_menu:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/pointer.svg"))
	else:
		Input.set_custom_mouse_cursor(load("res://addons/cursor/sight.png"))
