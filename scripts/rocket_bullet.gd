extends StaticBody2D

@onready var explosion_area:Area2D = $ExplosionArea
@onready var anim:AnimationPlayer = $AnimationPlayer

var speed:int = 150
var direction:Vector2
var shoot_owner:String
var damage:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+= direction*speed*delta


func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		body.hit(2)
	await anim.animation_finished
	call_deferred("queue_free")


func _on_timer_timeout() -> void:
	explosion_area.process_mode = Node.PROCESS_MODE_INHERIT
	anim.play("explosion")
