extends Node2D

@onready var sprite_node:Sprite2D = $LifeSprite

var duration: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node.modulate = Color("00ff07")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(duration)
	duration+=delta

func move(dur:float):
	position.y += sin(dur*5)*0.5
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		player.life+=1
		player.health_bar.update_ui(player.life,player.max_life,player.shield,player.max_shield)
		call_deferred("queue_free")
