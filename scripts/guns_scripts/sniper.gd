extends Gun

@onready var timer:Timer = $Timer

func _process(delta: float) -> void:
	if !is_reloading:
		if Input.is_action_just_pressed("mouse1") and actual_ammo>0 and !timer.time_left>0:
			fire()
			timer.start(5)
		if Input.is_action_just_pressed("reload") and actual_ammo<gun_pent and reload_cooldown<=0:
			reload()
	else:
		reload_cooldown-=delta
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
