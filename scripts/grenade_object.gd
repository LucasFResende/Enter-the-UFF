class_name Grenade
extends StaticBody2D

@onready var sprite:Sprite2D = $Sprite2D
@onready var explosion_area:Area2D = $ExplosionArea
var count:float = 0.0
var speed:int = 50
var direction:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_angle(delta)
	position+= direction*speed*delta

func process_angle(delta:float) -> void:
	count+=delta
	sprite.rotation = rotate_function(count)


func rotate_function(x:float)->float:
	return ((4*PI)/4.5)*x


func _on_timer_timeout() -> void:
	explosion_area.process_mode = Node.PROCESS_MODE_INHERIT
	

func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		body.hit(2)
	call_deferred("queue_free")
