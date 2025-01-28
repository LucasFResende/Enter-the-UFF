extends Node2D

var grenade_object:PackedScene = load("res://objects/grenade/grenade_object.tscn")
@onready var marker_position:Marker2D = $Sprite2D/Marker2D
@onready var sprite:Sprite2D = $Sprite2D

@export_category("Grenade Rotation")
@export var offset_necessary:Vector2

var angle:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1"):
		var player:Player = get_parent().get_parent()
		if player.actual_grenades>0:
			var grenade_launch:Grenade = grenade_object.instantiate()
			grenade_launch.global_position = marker_position.global_position
			grenade_launch.direction = (get_global_mouse_position() - grenade_launch.global_position).normalized()
			player.add_sibling(grenade_launch)
			player.actual_grenades-=1
			player.ammo_ui.update_grenade_ui(player.actual_grenades)
	ver_angle()
	if angle>90 and angle <270:
		sprite.offset=offset_necessary
		sprite.flip_v = true
	else:
		sprite.offset=Vector2.ZERO
		sprite.flip_v = false
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
