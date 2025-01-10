extends Area2D
class_name Shoot

var speed:int = 200
@onready var timer:Timer = $Timer
var direction:Vector2
var shoot_owner:String
var damage:int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+= direction*speed*delta



func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("object") :
		queue_free()
	if (body.is_in_group("player") and shoot_owner != "player") or ( body.is_in_group("enemy") and shoot_owner != "enemy"):
		body.hit(damage)
		queue_free()
