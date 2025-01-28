extends Gun

func _ready() -> void:
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,gun_icon)
	shoot_scene = load("res://objects/rocket bullet/rocket_bullet.tscn")

func shoot():
	var shoot_bullet = shoot_scene.instantiate() as StaticBody2D
	shoot_bullet.global_position = bullet_spawn_point.global_position
	shoot_bullet.direction = (get_global_mouse_position() - bullet_spawn_point.global_position).normalized()
	shoot_bullet.shoot_owner="player"
	get_parent().get_parent().add_sibling(shoot_bullet)
