extends Gun

var is_attacking:bool = false

var target_angle
var lerp_weight
var attack_second_part:bool = false
var last_angle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1"):
		attack(true)
		is_attacking = true
	if is_attacking:
		rotation = lerp_angle(rotation,target_angle,lerp_weight)
		if rotation == last_angle and !attack_second_part:
			attack(false)
			attack_second_part=true
			return
		if rotation == last_angle and attack_second_part:
			is_attacking = false
			attack_second_part = false
			return
		last_angle = rotation
	if !is_attacking:
		ver_angle()
		if angle>90 and angle <270:
			sprite.offset=offset_necessary
			sprite.flip_v = true
		else:
			sprite.offset=Vector2.ZERO
			sprite.flip_v = false
		rotation_degrees = angle
	
	
func attack(is_frist:bool):
	if is_frist:
		target_angle = deg_to_rad(rotation_degrees - 30.0)
		lerp_weight = 0.1
	else:
		target_angle = deg_to_rad(rotation_degrees + 60.0)
		lerp_weight = 0.3


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and is_attacking:
		var enemy:Enemy = body
		enemy.life = 1
		enemy.hit(1)
