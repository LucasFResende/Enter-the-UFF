extends CharacterBody2D
class_name Enemy

@export var speed:int = 2
@export var life:int = 3
var shoot_cooldown:float = 3.0
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var anim_sprite:AnimatedSprite2D = $AnimatedSprite2D
var is_moving:bool = false
@onready var find_player:Area2D = $FindPlayer
var is_burning:bool = false

var shoot_scene:PackedScene = load("res://objects/bullet/bullet.tscn")

var drop_item:PackedScene = load("res://objects/life_ammo drop/life_ammo__drop.tscn")

func _ready() -> void:
	find_player.body_entered.connect(on_find_player_body_entered)

func _physics_process(delta: float) -> void:
	if shoot_cooldown>0.0:
		shoot_cooldown-=delta
	else:
		shoot()
		shoot_cooldown=3.0
	if is_moving:
		move(delta)

func hit(damage:int):
	life-=damage
	if life == 1:
		anim.play("low_life_hit")
		await anim.animation_finished
		if is_moving:
			anim.play("walk_low_life")
	elif life<=0:
		get_parent().enemies_defeated+=1
		call_deferred("drop")
		queue_free()
	else:
		anim_sprite.play("hit")
		await anim_sprite.animation_finished
		if is_moving:
			anim_sprite.play("walk")

func shoot():
	var shoot_node:Node = get_parent()
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = position
	shoot_bullet.direction = (GameManager.player_position - global_position).normalized()
	shoot_bullet.shoot_owner = "enemy"
	sprite.texture = load("res://addons/objects/enemy_bullet.png")
	shoot_node.add_child(shoot_bullet)

func move(delta):
	var direction = (GameManager.player_position - global_position).normalized()
	position+= direction*speed*delta*30
	move_and_slide()

func on_find_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if life==1:
			anim.play("walk_low_life")
		else:
			anim_sprite.play("walk")
		is_moving = true

func drop():
	if randf()<=0.6:
		var instance:Node2D = drop_item.instantiate()
		instance.position = global_position
		get_parent().get_parent().add_child(instance)
