extends Gun

@onready var fire_particle:GPUParticles2D = $Sprite2D/Marker2D/Fire
@onready var fire_particle_area:Area2D = $Sprite2D/Marker2D/Fire/FireArea

var is_firing:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1") and actual_ammo>0:
		fire_particle.emitting = true
		fire_particle_area.process_mode = Node.PROCESS_MODE_INHERIT
		is_firing = true
	if Input.is_action_just_released("mouse1") or !actual_ammo>0:
		fire_particle.emitting = false
		fire_particle_area.process_mode = Node.PROCESS_MODE_DISABLED
		is_firing = false
	if is_firing:
		actual_ammo-=delta
		ammo_ui.update_gun_ui(int(actual_ammo),bag_ammo,gun_icon)
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

func ver_angle():
	var mouse_position = get_global_mouse_position()
	var player_mouse_direction = mouse_position - global_position
	var direction = player_mouse_direction.normalized()
	angle = rad_to_deg(atan(direction.y/direction.x))
	if direction.x<0:
		angle+=180
	if direction.x>0 and direction.y<0:
		angle+=360
	if direction.x==0 and direction.y==1:
		angle=90.0
	if direction.x==0 and direction.y==-1:
		angle=270.0

func reload():
	bag_ammo-=roundi(gun_pent-actual_ammo)
	actual_ammo=gun_pent
	ammo_ui.update_gun_ui(actual_ammo,bag_ammo,gun_icon)
