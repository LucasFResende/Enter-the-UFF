class_name Player
extends CharacterBody2D

var menu_scene:PackedScene = load("res://UI/menu_ui.tscn")

@export var SPEED:int = 3
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
var is_holding_grenade:bool = false

var coins:int = 0

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_hand:AnimatedSprite2D = $HandAnimation
@onready var anim_comp:AnimationPlayer = $AnimationPlayer
@onready var ammo_ui:CanvasLayer = $Camera2D/AmmoUi
@onready var no_enemy:Area2D = $NoEnemy
@onready var change_scene:CanvasLayer = $Camera2D/ChangeScene
@onready var gun_spawner:Marker2D = $SpawGun

@export var life:int = 6
var max_life:int = 7

var max_grenades = 3
var actual_grenades = 3

@onready var health_bar = $Camera2D/HealthBar/Health

const UP:Vector2 = Vector2(0,-1)
const DOWN:Vector2 = Vector2(0,1)
const LEFT:Vector2 = Vector2(1,0)
const RIGHT:Vector2 = Vector2(-1,0)

var items: Array

var gun_actual:Gun
var gun_1:Gun
var gun_2:Gun
var num_gun_actual:int = 1

func _ready() -> void:
	GameManager.is_in_game = true
	gun_actual = GameManager.player_actual_gun
	gun_1 = GameManager.player_gun_1
	gun_2 = GameManager.player_gun_2
	gun_spawner.add_child(gun_1)
	gun_spawner.add_child(gun_2)
	gun_2.process_mode = Node.PROCESS_MODE_DISABLED
	gun_2.visible = false
	gun_actual.update_ui()
	ammo_ui.update_grenade_ui(actual_grenades)

	no_enemy.body_entered.connect(on_no_enemy_body_entered)
	material.set("shader_parameter/hair_replace_color",GameManager.player_custom_hair)
	material.set("shader_parameter/shirt_replace_color",GameManager.player_custom_shirt)
	material.set("shader_parameter/emblem_replace_color",GameManager.player_custom_emblem)
	material.set("shader_parameter/shorts_replace_color",GameManager.player_custom_short)
	
	generate_items()

func _physics_process(delta: float) -> void:
	print(gun_1.name,gun_2.name)
	GameManager.player_position = global_position
	if Input.is_action_just_pressed("esc"):
		$Camera2D.add_child(menu_scene.instantiate())
	if GameManager.is_scene_changed:
		GameManager.can_spawn_map = true
		GameManager.is_scene_changed = false

	if death_cooldown>0:
		death_cooldown-=delta
		if death_cooldown<=0:
			get_tree().change_scene_to_file(GameManager.return_scene_path)
		return
	health_bar.update_health(life,max_life)
	if Input.is_action_just_pressed("gun1") or Input.is_action_just_pressed("gun2") or Input.is_action_just_pressed("scroll"):
		change_gun()
	if Input.is_action_just_pressed("grenade"):
		if is_holding_grenade:
			is_holding_grenade = false
			gun_spawner.get_child(1).queue_free()
			gun_spawner.get_child(0).visible = true
			gun_spawner.get_child(0).process_mode = Node.PROCESS_MODE_INHERIT
		elif !is_holding_grenade:
			gun_spawner.get_child(0).visible = false
			gun_spawner.get_child(0).process_mode = Node.PROCESS_MODE_DISABLED
			gun_spawner.get_child(0).add_sibling(load("res://guns/grenade.tscn").instantiate())
			is_holding_grenade = true
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
	

	ver_angle()
	if input and !is_sliding:
		is_moving = true
		var target_position:Vector2 = position+input*SPEED*delta*50
		position = lerp(position,target_position,1)
	else:
		is_moving = false
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		collision = get_slide_collision(i).get_collider()
		if (collision.name == "VerticalTable" or collision.name == "HorizontalTable") and Input.is_action_just_pressed("mouse2"):
			is_sliding = true
			is_rolling = false
			table_slide(collision.name)
		elif (collision.name == "VerticalTable" or collision.name == "HorizontalTable") and Input.is_action_just_pressed("interact"):
			flip_table()


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
				play_animationplayer("roll_front2",false)
				is_rolling = true
			if input == Vector2(1,1):
				play_animationplayer("roll_front2",false)
				is_rolling = true
			if input == Vector2(0,1):
				play_animationplayer("roll_front1",false)
				is_rolling = true
			if input == Vector2(-1,1):
				play_animationplayer("roll_front2",true)
				is_rolling = true
			if input == Vector2(-1,0):
				play_animationplayer("roll_front2",true)
				is_rolling = true
			if input == Vector2(-1,-1):
				play_animationplayer("roll_back2",true)
				is_rolling = true
			if input == Vector2(0,-1):
				play_animationplayer("roll_back1",false)
				is_rolling = true
			if input == Vector2(1,-1):
				play_animationplayer("roll_back2",false)
				is_rolling = true
		if angle< 341 and angle>307 and !is_rolling:
			play_animationplayer("walk_back2",false)
			
		if angle<307 and angle>270 and !is_rolling:
			play_animationplayer("walk_back1",false)
			
		if angle<270 and angle>230 and !is_rolling:
			play_animationplayer("walk_back1",true)
			
		if angle<230 and angle>198 and !is_rolling:
			play_animationplayer("walk_back2",true)
			
		if angle<198 and angle>121 and !is_rolling:
			play_animationplayer("walk_front2",true)
			
		if angle<121 and angle>90 and !is_rolling:
			play_animationplayer("walk_front1",true)
			
		if angle<90 and angle>56 and !is_rolling:
			play_animationplayer("walk_front1",false)
			
		if angle<56 and (angle>0 or angle>341) and !is_rolling:
			play_animationplayer("walk_front2",false)
			
	else:
		if angle< 341 and angle>307 and !is_rolling:
			play_animationplayer("idle_back2",false)
			
		if angle<307 and angle>270 and !is_rolling:
			play_animationplayer("idle_back1",false)
			
		if angle<270 and angle>230 and !is_rolling:
			play_animationplayer("idle_back1",true)
			
		if angle<230 and angle>198 and !is_rolling:
			play_animationplayer("idle_back2",true)
			
		if angle<198 and angle>121 and !is_rolling:
			play_animationplayer("idle_front2",true)
			
		if angle<121 and angle>90 and !is_rolling:
			play_animationplayer("idle_front1",true)
			
		if angle<90 and angle>56 and !is_rolling:
			play_animationplayer("idle_front1",false)
			
		if angle<56 and (angle>0 or angle>341) and !is_rolling:
			play_animationplayer("idle_front2",false)
			
func table_slide(object):
	z_index=1
	if (object == "HorizontalTable" and (input==UP or input==DOWN)) or (object == "VerticalTable" and (input==LEFT or input==RIGHT)) :
		PARAM = 15
	elif (object == "HorizontalTable" and (input==LEFT or input==RIGHT)) or (object == "VerticalTable" and (input==UP or input==DOWN)) :
		PARAM = 25
	$CollisionShape2D.disabled = true
	play_animationplayer("table_slide")

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
		play_animationplayer("flip_front1")
	if input == RIGHT:
		play_animationplayer("flip_front2",true)
	if input == LEFT:
		play_animationplayer("flip_front2")
	if input == UP:
		play_animationplayer("flip_back")



func hit(damage:int):
	life-=damage
	
	if life==0:
		play_animationplayer("death")
		death_cooldown = 3.6
		return


func on_no_enemy_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.is_moving = false

func play_animationplayer(animation_name:String,bool_anim:bool = false):
	anim.flip_h = bool_anim
	anim_hand.flip_h = bool_anim
	if bool_anim:
		gun_spawner.position=Vector2(-5,4)
	else:
		gun_spawner.position=Vector2(6,4)
	anim_comp.play(animation_name)

func change_gun():
	if (Input.is_action_just_pressed("gun1") and gun_actual!=gun_1) or (Input.is_action_just_pressed("scroll") and gun_actual==gun_2):
		gun_actual = gun_1
		num_gun_actual = 1
		gun_2.process_mode = Node.PROCESS_MODE_DISABLED
		gun_2.visible = false
		gun_1.process_mode = Node.PROCESS_MODE_INHERIT
		gun_1.visible = true
		gun_actual.update_ui()
	elif (Input.is_action_just_pressed("gun2") and gun_actual!=gun_2) or (Input.is_action_just_pressed("scroll") and gun_actual==gun_1):
		gun_actual = gun_2
		num_gun_actual = 2
		gun_1.process_mode = Node.PROCESS_MODE_DISABLED
		gun_1.visible = false
		gun_2.process_mode = Node.PROCESS_MODE_INHERIT
		gun_2.visible = true
	gun_actual.update_ui()

func active():
	process_mode = PROCESS_MODE_INHERIT
	visible = true
	ammo_ui.visible = true
	
func generate_items():
	items.append(gun_1)
	items.append(gun_2)
	for i in range(5):
		items.append(GameManager.guns.pick_random().instantiate())
	items.append(load("res://objects/itens/hd.tscn").instantiate())
	items.append(load("res://objects/itens/pendrive.tscn").instantiate())
	items.append(load("res://objects/itens/ssd.tscn").instantiate())
	items.append(load("res://objects/itens/nvme.tscn").instantiate())
