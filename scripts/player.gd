class_name Player
extends CharacterBody2D

var shoot_scene:PackedScene = load("res://objects/bullet/bullet.tscn")

@export var SPEED = 3
var angle: float
var is_moving:bool = false
var input: Vector2
var is_rolling: bool = false
var rollin_cooldow:float = 1.6
var table_slide_cooldow:float = 0.6
var is_sliding:bool = false
var collision:Object
var PARAM:float
var is_flipping:bool = false
var flipping_cooldown:float = 0.8
var death_cooldown:float = 0
var can_shoot:bool = false

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var ammo_ui:CanvasLayer = $Camera2D/AmmoUi
@onready var no_enemy:Area2D = $NoEnemy
@onready var change_scene:CanvasLayer = $Camera2D/ChangeScene
@export var life:int = 6
var max_life:int = 7

var actual_ammo:int = 7
var gum_pent:int = 7
var bag_ammo:int = 60

@onready var health_bar = $Camera2D/HealthBar/Health

const UP:Vector2 = Vector2(0,-1)
const DOWN:Vector2 = Vector2(0,1)
const LEFT:Vector2 = Vector2(1,0)
const RIGHT:Vector2 = Vector2(-1,0)

func _ready() -> void:
	ammo_ui.update_ui(actual_ammo,bag_ammo)
	no_enemy.body_entered.connect(on_no_enemy_body_entered)

func _physics_process(delta: float) -> void:
	print("A")
	if GameManager.is_scene_changed:
		position = GameManager.set_position
		GameManager.is_scene_changed = false
	if death_cooldown>0:
		death_cooldown-=delta
		if death_cooldown<=0:
			get_tree().reload_current_scene()
		return
	health_bar.update_health(life,max_life)
	if is_sliding:
		process_table_slide(delta)
		return
	if flipping_cooldown>0 and is_flipping:
		flipping_cooldown-=delta
		return
	else:
		flipping_cooldown = 0.8
		is_flipping = false 
		
	if rollin_cooldow > 0 and is_rolling:
		rollin_cooldow-=delta
	else:
		rollin_cooldow=1.6
		is_rolling = false
	process_input()
	if Input.is_action_just_pressed("reload") and actual_ammo<gum_pent:
		bag_ammo-=(gum_pent-actual_ammo)
		actual_ammo=gum_pent
		ammo_ui.update_ui(actual_ammo,bag_ammo)
	fire()
	ver_angle()
	if input and !is_sliding:
		is_moving = true
		position += input*SPEED*delta*50
	else:
		is_moving = false
		
	move_and_slide()
	GameManager.player_position = position
	for i in get_slide_collision_count():
		collision = get_slide_collision(i).get_collider()
		if (collision.name == "VerticalTable" or collision.name == "HorizontalTable") and Input.is_action_just_pressed("mouse2"):
			is_sliding = true
			is_rolling = false
			table_slide(collision.name)
		elif (collision.name == "VerticalTable" or collision.name == "HorizontalTable") and Input.is_action_just_pressed("interact"):
			flip_table()

func fire():
	if Input.is_action_just_pressed("mouse1") and actual_ammo>0 and !can_shoot:
		actual_ammo-=1
		shoot()
		ammo_ui.update_ui(actual_ammo,bag_ammo)
		

func process_input():
	input = Input.get_vector("left","right","up","down")
	if input.x>0:
		input.x = 1
	if input.x<0:
		input.x=-1
	if input.y>0:
		input.y=1
	if input.y<0:
		input.y=-1

func ver_angle():
	var mouse_position = get_global_mouse_position()
	var player_mouse_direction = mouse_position - position
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
	play_animation()

func play_animation():
	if is_moving:
		if Input.is_action_just_pressed("mouse2"):
			if input == Vector2(1,0):
				anim.flip_h = false
				anim.play("roll_front2")
				is_rolling = true
			if input == Vector2(1,1):
				anim.flip_h = false
				anim.play("roll_front2")
				is_rolling = true
			if input == Vector2(0,1):
				anim.flip_h = false
				anim.play("roll_front1")
				is_rolling = true
			if input == Vector2(-1,1):
				anim.flip_h = true
				anim.play("roll_front2")
				is_rolling = true
			if input == Vector2(-1,0):
				anim.flip_h = true
				anim.play("roll_front2")
				is_rolling = true
			if input == Vector2(-1,-1):
				anim.flip_h = true
				anim.play("roll_back2")
				is_rolling = true
			if input == Vector2(0,-1):
				anim.flip_h = false
				anim.play("roll_back1")
				is_rolling = true
			if input == Vector2(1,-1):
				anim.flip_h = false
				anim.play("roll_back2")
				is_rolling = true
		if angle< 341 and angle>307 and !is_rolling:
			anim.flip_h = false
			anim.play("walk_back2")
		if angle<307 and angle>270 and !is_rolling:
			anim.flip_h = false
			anim.play("walk_back1")
		if angle<270 and angle>230 and !is_rolling:
			anim.flip_h = true
			anim.play("walk_back1")
		if angle<230 and angle>198 and !is_rolling:
			anim.flip_h = true
			anim.play("walk_back2")
		if angle<198 and angle>121 and !is_rolling:
			anim.flip_h = true
			anim.play("walk_front2")
		if angle<121 and angle>90 and !is_rolling:
			anim.flip_h = true
			anim.play("walk_front1")
		if angle<90 and angle>56 and !is_rolling:
			anim.flip_h = false
			anim.play("walk_front1")
		if angle<56 and (angle>0 or angle>341) and !is_rolling:
			anim.flip_h = false
			anim.play("walk_front2")
	else:
		if angle< 341 and angle>307 and !is_rolling:
			anim.flip_h = false
			anim.play("idle_back2")
		if angle<307 and angle>270 and !is_rolling:
			anim.flip_h = false
			anim.play("idle_back1")
		if angle<270 and angle>230 and !is_rolling:
			anim.flip_h = true
			anim.play("idle_back1")
		if angle<230 and angle>198 and !is_rolling:
			anim.flip_h = true
			anim.play("idle_back2")
		if angle<198 and angle>121 and !is_rolling:
			anim.flip_h = true
			anim.play("idle_front2")
		if angle<121 and angle>90 and !is_rolling:
			anim.flip_h = true
			anim.play("idle_front1")
		if angle<90 and angle>56 and !is_rolling:
			anim.flip_h = false
			anim.play("idle_front1")
		if angle<56 and (angle>0 or angle>341) and !is_rolling:
			anim.flip_h = false
			anim.play("idle_front2")
			
func table_slide(object):
	z_index=1
	if (object == "HorizontalTable" and (input==UP or input==DOWN)) or (object == "VerticalTable" and (input==LEFT or input==RIGHT)) :
		PARAM = 15
	elif (object == "HorizontalTable" and (input==LEFT or input==RIGHT)) or (object == "VerticalTable" and (input==UP or input==DOWN)) :
		PARAM = 25
	$CollisionShape2D.disabled = true
	anim.play("table_slide")

func process_table_slide(delta):
	if table_slide_cooldow>0 and is_sliding:
		position += input*SPEED*delta*PARAM
		table_slide_cooldow-=delta
	else:
		$CollisionShape2D.disabled = false
		table_slide_cooldow=0.6
		is_sliding = false

func flip_table():
	is_flipping = true
	collision.flip.emit(input)
	if input == DOWN:
		anim.play("flip_front1")
	if input == RIGHT:
		anim.flip_h = true
		anim.play("flip_front2")
	if input == LEFT:
		anim.play("flip_front2")
	if input == UP:
		anim.play("flip_back")

func shoot():
	var shoot_node:Node = get_parent().get_child(0)
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = position
	print(shoot_bullet.position,position)
	shoot_bullet.direction = (get_global_mouse_position() - position).normalized()
	shoot_bullet.shoot_owner="player"
	sprite.texture = load("res://addons/objects/player_bullet.png")
	shoot_node.add_child(shoot_bullet)

func hit(damage:int):
	life-=damage
	if life==0:
		anim.play("death")
		death_cooldown = 3.6
		return


func on_no_enemy_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.is_moving = false
