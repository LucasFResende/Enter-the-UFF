class_name LevelParent
extends Node2D

var shoot_scene: PackedScene = preload("res://objects/bullet/bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func create_shoot(pos,direction,type):
	var shoot:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot.get_child(1)
	shoot.position = pos
	shoot.direction = direction
	shoot.shoot_owner = type
	if type == "player":
		sprite.texture = preload("res://addons/objects/player_bullet.png")
		$PlayerShoot.add_child(shoot)
	elif type == "enemy":
		sprite.texture = preload("res://addons/objects/enemy_bullet.png")
		$EnimieShoot.add_child(shoot)
