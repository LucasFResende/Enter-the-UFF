class_name Gun
extends Node2D

var shoot_scene:PackedScene = load("res://objects/bullet/bullet.tscn")

enum rarity {COMMON,UNCOMMON,RARE,EPIC,LEGENDARY}

var gun_rarity:rarity

var equiped_panel:Texture
var inv_panel:Texture
var panel:Texture
var rarity_color:Color
var rarity_percent:int

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
	if actual_ammo>0:
		shoot()
		actual_ammo-=1
		update_ui()

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
	update_ui()

func update_ui():
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,icon,rarity_color)

func pick_rarity():
	gun_rarity = rarity.values().pick_random()
	if gun_rarity == rarity.UNCOMMON:
		equiped_panel = load("res://addons/ui/uncommon_panel_inv_eq.png")
		inv_panel = load("res://addons/ui/uncommon_panel_inv.png")
		panel = load("res://addons/ui/uncommon_panel.png")
		rarity_color = Color("a9a9a9")
		sell_price = sell_price * 1
	elif gun_rarity == rarity.COMMON:
		equiped_panel = load("res://addons/ui/common_panel_inv_eq.png")
		inv_panel = load("res://addons/ui/common_panel_inv.png")
		panel = load("res://addons/ui/common_panel.png")
		rarity_color = Color("32cd32") 
		sell_price = sell_price * 2
	elif gun_rarity == rarity.RARE:
		equiped_panel = load("res://addons/ui/rare_panel_inv_eq.png")
		inv_panel = load("res://addons/ui/rare_panel_inv.png")
		panel = load("res://addons/ui/rare_panel.png")
		rarity_color = Color("2e8df4")
		sell_price = sell_price * 3
	elif gun_rarity == rarity.EPIC:
		equiped_panel = load("res://addons/ui/epic_panel_inv_eq.png")
		inv_panel = load("res://addons/ui/epic_panel_inv.png")
		panel = load("res://addons/ui/epic_panel.png")
		rarity_color = Color("8645b2") 
		sell_price = sell_price * 4
	elif gun_rarity == rarity.LEGENDARY:
		equiped_panel = load("res://addons/ui/legendary_panel_inv_eq.png")
		inv_panel = load("res://addons/ui/legendary_panel_inv.png")
		panel = load("res://addons/ui/legendary_panel.png")
		rarity_color = Color("d50000")
		sell_price = sell_price * 5
