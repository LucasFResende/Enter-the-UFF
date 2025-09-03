extends Marker2D

var shoot_scene:PackedScene = load("res://objects/power_shoot/shoot.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and player.is_in_dungeon:
		shoot()

func shoot():
	var direction = (get_global_mouse_position() - player.position).normalized()
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = player.position + direction*15
	shoot_bullet.direction = direction
	shoot_bullet.shoot_owner="player"
	sprite.texture = load("res://addons/objects/player_shoot.png")
	get_parent().get_parent().add_sibling(shoot_bullet)
