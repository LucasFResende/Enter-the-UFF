extends Marker2D

var shoot_scene:PackedScene = load("res://objects/power_shoot/shoot.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and player.is_in_dungeon and player.stamina>0:
		shoot()
		player.stamina-=1

func shoot():
	var direction = (get_global_mouse_position() - player.position).normalized()
	var shoot_bullet:Shoot = shoot_scene.instantiate() as Area2D
	var sprite:Sprite2D = shoot_bullet.get_child(1)
	shoot_bullet.position = player.position + direction*15
	shoot_bullet.direction = direction
	shoot_bullet.shoot_owner="player"
	shoot_bullet.damage = player.power_damage
	sprite.texture = load("res://addons/objects/player_shoot.png")
	get_parent().get_parent().add_sibling(shoot_bullet)
	player.is_recovering_stamina = false
	player.recovering_stamina_cooldown = 3.0
	player.recover_stamina_time = 1.0
