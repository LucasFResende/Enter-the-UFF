extends Gun

var bullet_cooldown:float = 300
@onready var timer:Timer = $Timer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and actual_ammo>0:
		fire()
		timer.start(0.05)
		await timer.timeout
		fire()
		timer.start(0.05)
		await timer.timeout
		fire()
		timer.start(0.05)
		await timer.timeout
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
