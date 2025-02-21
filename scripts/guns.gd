class_name Gun
extends Node2D

var shoot_scene:PackedScene = load("res://objects/bullet/bullet.tscn")

var angle:float
@onready var sprite:Sprite2D = $Sprite2D
@onready var bullet_spawn_point:Marker2D = $Sprite2D/Marker2D
@onready var ammo_ui:CanvasLayer = get_parent().get_parent().get_child(5).get_child(2)

@export_category("Gun info")
@export var icon:Texture2D
@export var gun_name:String
@export var sell_price:int

@export_category("Gun Rotation")
@export var offset_necessary:Vector2
@export var bullet_position:Vector2
@export var offset_bullet_position:Vector2

@export_category("Gun ammo")
@export var gun_pent:int
@export var bag_ammo:int = 60

@onready var actual_ammo:int = gun_pent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and actual_ammo>0:
		fire()
	if Input.is_action_just_pressed("reload") and actual_ammo<gun_pent:
		reload()
	ver_angle()
	if angle>90 and angle <270:
		sprite.offset=offset_necessary
		sprite.flip_v = true
		bullet_spawn_point.position = offset_bullet_position
	else:
		sprite.offset=Vector2.ZERO
		sprite.flip_v = false
		bullet_spawn_point.position = bullet_position
	rotation_degrees = angle

func ver_angle():
	var mouse_position = get_global_mouse_position()
	var player_mouse_direction = mouse_position - global_position
	var direction = player_mouse_direction.normalized()
	angle = rad_to_deg(atan(direction.y/direction.x))
	if direction.x<0:
		angle+=180
	if direction.x>0 and direction.y<0:
		angle+=360
	if direction.x==0 and direction.y==1:
		angle=90.0
	if direction.x==0 and direction.y==-1:
		angle=270.0

func fire():
	shoot()
	actual_ammo-=1
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,icon)

func shoot():
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = bullet_spawn_point.global_position
	shoot_bullet.direction = (get_global_mouse_position() - bullet_spawn_point.global_position).normalized()
	shoot_bullet.shoot_owner="player"
	sprite.texture = load("res://addons/objects/player_bullet.png")
	get_parent().get_parent().add_sibling(shoot_bullet)

func reload():
	bag_ammo-=(gun_pent-actual_ammo)
	actual_ammo=gun_pent
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,icon)

func update_ui():
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,icon)
