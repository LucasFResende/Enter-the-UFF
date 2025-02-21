extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var rooms_node:Node = $Rooms
@onready var initial_grid: Image = InitialRoom.texture.get_image()
var center_coord = Vector2(0,0)
var path_spawn: Array[Vector2] = [Vector2(0,-312),Vector2(0,312),Vector2(312,0),Vector2(-312,0)]
@onready var down_path_img:Image = DownPath.texture.get_image()
@onready var left_path_img: Image = LeftPath.texture.get_image()
@onready var right_path_img: Image = RightPath.texture.get_image()
@onready var up_path_img: Image = UpPath.texture.get_image()
@onready var room_img:Image = Room.texture.get_image()
@onready var exit_img:Image = Exit.texture.get_image()
@onready var path_array: Array = [down_path_img,up_path_img,right_path_img,left_path_img]
@onready var tables:Array[PackedScene] = [load("res://objects/table/horizontal_table.tscn"),load("res://objects/table/vertical_table.tscn")]
var direction_generetion:int

var spawn_min_x:int = -208
var spawn_max_x:int = 208
var spawn_min_y:int = -128
var spawn_max_y:int = 128


var room_scene:PackedScene = load("res://room/room.tscn")
var exit_scene:PackedScene = load("res://room/exit.tscn")

var num_rooms:int = randi_range(10,15)
var rooms_center: Array[Vector2] = [Vector2(0,32),Vector2(0,-32),Vector2(32,0),Vector2(-32,0),Vector2(32,32),Vector2(32,-32),Vector2(-32,32),Vector2(-32,-32),]

var is_first:bool = true
var first_displacement: Array[Vector2] = [Vector2(-48,112),Vector2(-48,-320),Vector2(112,-48),Vector2(-320,-48)]
var displacement: Array[Vector2] = [Vector2(-48,144),Vector2(-48,-352),Vector2(224,-48),Vector2(-432,-48)]
var direction: Array[Vector2] = [Vector2(0,1),Vector2(0,-1), Vector2(1,0),Vector2(-1,0)] 

var start_cooldown:float = 1.0

var coord:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_map()
	rooms_center.append(center_coord)

func _process(delta: float) -> void:
	if start_cooldown>0:
		start_cooldown-=delta
		return
	if GameManager.can_spawn_map and num_rooms>0:
		direction_generetion = randi_range(0,3)
		if (direction_generetion == 0 or direction_generetion ==1) and is_first:
			set_map(room_img,center_coord-Vector2(240,160)+direction[direction_generetion]*464)
			set_map(path_array[direction_generetion],center_coord+first_displacement[direction_generetion])
			center_coord+= direction[direction_generetion]*464
			rooms_center.append(center_coord)
			is_first = false
		elif (direction_generetion==2 or direction_generetion==3) and is_first:
			set_map(room_img,center_coord-Vector2(240,160)+direction[direction_generetion]*544)
			set_map(path_array[direction_generetion],center_coord+first_displacement[direction_generetion])
			center_coord+= direction[direction_generetion]*544
			rooms_center.append(center_coord)
			is_first = false
		else:
			generate_map()
		add_room()
		num_rooms-=1
		GameManager.can_spawn_map = false
	if num_rooms==0 and GameManager.can_spawn_map:
		generate_exit()

func start_map():
	for i in range(initial_grid.get_width()):
		for j in range(initial_grid.get_height()):
			coord = Vector2(i,j)
			var color = initial_grid.get_pixel(i,j)
			if color == Color("3209ee"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(2,1),0)
			elif color == Color("1da300"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(1,0),0)
			elif color == Color("ee0909"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(0,2),0)
			elif color == Color("04b6e6"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(1,2),0)
			elif color == Color("e604c6"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(0,0),0)
			elif color == Color("deee09"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,3),0)
			elif color == Color("a937fa"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,0),0)
			elif color == Color("00fa21"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,1),0)
			elif color == Color("fa9e00"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,2),0)
			elif color == Color("ff0062"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(4,1),0)
			elif color == Color("00ff6b"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(4,0),0)
			elif color == Color("b3ff00"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(4,3),0)
			elif color == Color("ff6300"): 
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(4,2),0)
			elif color == Color("ffffff"):
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(2,4),0)
			elif color == Color("fffbff"):
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(2,5),0)
			elif color == Color("fffcff"):
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,4),0)
			elif color == Color("fffdff"):
				ground.set_cell(ground.local_to_map(coord-Vector2(128,128)),0,Vector2(3,5),0)
	ground.update_internals()

func set_map(img:Image,start:Vector2):
	for i in range(img.get_width()):
		for j in range(img.get_height()):
			coord = Vector2(i,j)
			var color = img.get_pixel(i,j)
			if color == Color("3209ee"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(2,1),0)
			elif color == Color("1da300"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(1,0),0)
			elif color == Color("ee0909"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(0,2),0)
			elif color == Color("04b6e6"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(1,2),0)
			elif color == Color("e604c6"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(0,0),0)
			elif color == Color("deee09"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,3),0)
			elif color == Color("a937fa"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,0),0)
			elif color == Color("00fa21"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,1),0)
			elif color == Color("fa9e00"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,2),0)
			elif color == Color("ff0062"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,1),0)
			elif color == Color("00ff6b"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,0),0)
			elif color == Color("b3ff00"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,3),0)
			elif color == Color("ff6300"): 
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,2),0)
			elif color == Color("ffffff"):
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,4),0)
			elif color == Color("fffbff"):
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(3,5),0)
			elif color == Color("fffcff"):
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,4),0)
			elif color == Color("fffdff"):
				ground.set_cell(ground.local_to_map(coord+start),0,Vector2(4,5),0)
			
			
	ground.update_internals()


func generate_map():
	direction_generetion = randi_range(0,3)
	while center_coord+direction[direction_generetion]*496 in rooms_center or center_coord+direction[direction_generetion]*656 in rooms_center:
		direction_generetion = randi_range(0,3)
	
	if direction_generetion == 0 or direction_generetion ==1:
		set_map(room_img,center_coord-Vector2(240,160)+direction[direction_generetion]*496)
		set_map(path_array[direction_generetion],center_coord+displacement[direction_generetion])
		center_coord+= direction[direction_generetion]*496
		rooms_center.append(center_coord)
	else:
		set_map(room_img,center_coord-Vector2(240,160)+direction[direction_generetion]*656)
		set_map(path_array[direction_generetion],center_coord+displacement[direction_generetion])
		center_coord+= direction[direction_generetion]*656
		rooms_center.append(center_coord)
	generate_table()
	
func add_room():
	var instance:Node = room_scene.instantiate()
	instance.position = center_coord
	rooms_node.add_child(instance)

func generate_exit():
	#generate_map(exit_img)
	direction_generetion = randi_range(0,3)
	while center_coord+direction[direction_generetion]*496 in rooms_center or center_coord+direction[direction_generetion]*656 in rooms_center:
		direction_generetion = randi_range(0,3)
	if (direction_generetion == 0 or direction_generetion ==1):
		set_map(exit_img,center_coord-Vector2(128,128)+direction[direction_generetion]*464)
		set_map(path_array[direction_generetion],center_coord+displacement[direction_generetion])
		center_coord+= direction[direction_generetion]*464
	elif (direction_generetion==2 or direction_generetion==3):
		set_map(exit_img,center_coord-Vector2(128,128)+direction[direction_generetion]*544)
		set_map(path_array[direction_generetion],center_coord+displacement[direction_generetion])
		center_coord+= direction[direction_generetion]*544
	GameManager.can_spawn_map = false
	var instance = exit_scene.instantiate()
	instance.position = center_coord
	add_child(instance)

func generate_table():
	var num_table:int = [0,0,0,0,0,1,1,1,2,2].pick_random()
	for i in range(num_table):
		var table = tables.pick_random()
		var table_x_position = randf_range(spawn_min_x,spawn_max_x)+center_coord.x
		var table_y_position = randf_range(spawn_min_y,spawn_max_y)+center_coord.y
		var instance_table = table.instantiate()
		instance_table.position = Vector2(table_x_position,table_y_position)
		add_child(instance_table)
