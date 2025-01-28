extends GPUParticles2D


func _on_fire_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy:Enemy = body
		enemy.hit(1)
		enemy.is_burning = true
