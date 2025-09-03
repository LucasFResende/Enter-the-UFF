class_name Player
extends CharacterBody2D

var menu_scene:PackedScene = load("res://UI/menu_ui.tscn")

@export var SPEED:float = 3
var SPEED_default:float = 3
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
var is_in_pc:bool = false
var is_scene_changing:bool = false
var shield_recover_cooldow:float
var is_shield_recovering:bool = false
var is_in_dungeon:bool = false

var coins:int = 0

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_hand:AnimatedSprite2D = $HandAnimation
@onready var anim_comp:AnimationPlayer = $AnimationPlayer
@onready var no_enemy:Area2D = $NoEnemy
@onready var change_scene:CanvasLayer = $Camera2D/ChangeScene
@onready var camera:Camera2D = $Camera2D
@onready var health_bar = $Camera2D/HealthBar/Health

@export var life:int = 6
var max_life:int = 7
var max_life_default:int = 7

@export var max_shield:int = 0
var shield: int =0
var max_shield_default:int = 0

var flags:Dictionary = {
	"health_flag":0,
	"half_health_flag":0,
	"shield_flag":0,
	"half_shield_flag":0,
	"speed_flag":0,
	"reload_speed": 0,
	"drop_luck":0,
	"luck":0
}

var max_grenades = 3
var actual_grenades = 3


const UP:Vector2 = Vector2(0,-1)
const DOWN:Vector2 = Vector2(0,1)
const LEFT:Vector2 = Vector2(1,0)
const RIGHT:Vector2 = Vector2(-1,0)

var is_dead:bool = false

var hair_color:Color = Color("000000")
var shirt_color:Color = Color("111113")
var emblem_color:Color = Color("6abe30")
var short_color:Color = Color("394f78")

var items: Array

func _ready() -> void:
	GameManager.is_in_game = true

	no_enemy.body_entered.connect(on_no_enemy_body_entered)
	
func _physics_process(delta: float) -> void:
	if !is_in_pc and !is_scene_changing:
		GameManager.player_position = global_position
		if GameManager.is_scene_changed:
			GameManager.can_spawn_map = true
			GameManager.is_scene_changed = false
		
		if is_shield_recovering or shield_recover_cooldow==-1:
			shield_recover_cooldow-=delta
			if shield_recover_cooldow<=0:
				shield=max_shield
				is_shield_recovering = false
		
		if death_cooldown>0:
			death_cooldown-=delta
			if death_cooldown<=0:
				change_scene.change_scene(GameManager.return_scene_path,GameManager.return_local)
				await change_scene.anim.animation_finished
				life = max_life
				is_dead = false
			return
		health_bar.update_health(life,max_life,shield,max_shield)
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
	if shield>0:
		shield-=1
		shield_recover_cooldow = 3
		is_shield_recovering = true
		return
	life-=damage
	
	if life==0:
		is_dead = true
		play_animationplayer("death")
		death_cooldown = 3.6
		return


func on_no_enemy_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.is_moving = false

func play_animationplayer(animation_name:String,bool_anim:bool = false):
	anim.flip_h = bool_anim
	anim_hand.flip_h = bool_anim
	anim_comp.play(animation_name)


func active():
	process_mode = PROCESS_MODE_INHERIT
	visible = true
	health_bar.visible = true


func check_flags():
	max_life = max_life_default + flags["half_health_flag"] + flags["health_flag"]*2
	max_shield = max_shield_default + flags["half_shield_flag"] + flags["shield_flag"]*2
	is_shield_recovering = true
	SPEED = SPEED_default + flags["speed_flag"]*0.7
	health_bar.update_health(life,max_life,shield,max_shield)
