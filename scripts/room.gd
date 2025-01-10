extends Node2D

@onready var block: TileMapLayer = $Block
@onready var enemies_room = GameManager.enimeis_array

var enemy_position:Vector2
var can_spawn_enemy:bool = false
var spawn_rounds = 1
var enemies_defeated:int = 0
@onready var enemy_spawn_amount_round_1:int = randi_range(4,7)
@onready var enemy_spawn_amount_round_2:int = randi_range(4,7)

@onready var chest:PackedScene = load("res://objects/chest/chest.tscn")

var spawn_min_x:int = -208
var spawn_max_x:int = 208
var spawn_min_y:int = -128
var spawn_max_y:int = 128

var round_cooldown:float

func _process(delta: float) -> void:
	if round_cooldown>0:
		round_cooldown-=delta
		return
	if can_spawn_enemy == true and round_cooldown<=0:
		spawn()
		can_spawn_enemy = false
		enemies_defeated=0
	ver_round()

func spawn():
	if spawn_rounds==2:
		for i in range(enemy_spawn_amount_round_1):
			spawn_enemy()
	elif spawn_rounds==1:
		for i in range(enemy_spawn_amount_round_2):
			spawn_enemy()

func spawn_enemy():
	var enemy:PackedScene = enemies_room.pick_random()
	var enemy_instance:Node = enemy.instantiate()
	enemy_position.x = randf_range(spawn_min_x,spawn_max_x)
	enemy_position.y = randf_range(spawn_min_y,spawn_max_y)
	enemy_instance.position = enemy_position
	add_child(enemy_instance)
	
func ver_round():
	if (spawn_rounds==2 and enemies_defeated==enemy_spawn_amount_round_1):
		round_cooldown=2.0
		can_spawn_enemy = true
		spawn_rounds-=1
	if spawn_rounds==1 and enemies_defeated==enemy_spawn_amount_round_2:
		spawn_rounds-=1
	if spawn_rounds==0:
		clear_room()
		
func clear_room():
	GameManager.can_spawn_map = true
	var instance = chest.instantiate()
	instance.position.x = randf_range(spawn_min_x,spawn_max_x)+global_position.x
	instance.position.y = randf_range(spawn_min_y,spawn_max_y)+global_position.y
	get_parent().add_child(instance)
	queue_free()
