extends Gun

@onready var timer:Timer = $Timer


var shoot_angle_degree:float = 20
var t1:Transform2D = Transform2D()
var t2:Transform2D = Transform2D()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and actual_ammo>0 and !timer.time_left>0:
		fire()
		timer.start(1)
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

func fire():
	get_shoots_direction()
	
	_shoot((get_global_mouse_position() - bullet_spawn_point.global_position).normalized())
	_shoot((get_global_mouse_position() - bullet_spawn_point.global_position).normalized()*t1)
	_shoot((get_global_mouse_position() - bullet_spawn_point.global_position).normalized()*t2)
	actual_ammo-=1
	update_ui()

func _shoot(direction:Vector2):
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = bullet_spawn_point.global_position
	shoot_bullet.direction = direction
	shoot_bullet.shoot_owner="player"
	sprite.texture = load("res://addons/objects/player_bullet.png")
	get_parent().get_parent().add_sibling(shoot_bullet)


func get_shoots_direction():
	var rot1 = deg_to_rad(shoot_angle_degree)
	var rot2 = deg_to_rad(360-shoot_angle_degree)
	t1.x.x = cos(rot1)
	t1.y.y = cos(rot1)
	t1.x.y = sin(rot1)
	t1.y.x = -sin(rot1)
	t2.x.x = cos(rot2)
	t2.y.y = cos(rot2)
	t2.x.y = sin(rot2)
	t2.y.x = -sin(rot2)
