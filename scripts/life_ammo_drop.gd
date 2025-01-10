extends Node2D

@onready var sprite_node:Sprite2D = $LifeAmmoSprite

var duration: float
enum types {life, ammo}

@onready var type:types = types.values().pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == types.life:
		sprite_node.modulate = Color("00ff07")
	elif type == types.ammo:
		sprite_node.modulate = Color("220dff")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(duration)
	duration+=delta

func move(dur:float):
	position.y += sin(dur*5)*0.5
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		if type == types.life:
			player.life+=1
			player.health_bar.update_health(player.life,player.max_life)
			queue_free()
		elif type == types.ammo:
			player.bag_ammo+=30
			player.ammo_ui.update_ui(player.actual_ammo,player.bag_ammo)
			queue_free()
