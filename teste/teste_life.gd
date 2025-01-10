extends Area2D

enum types {regen,damage,inc_max_life,inc_ammo}

@export var type : types

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		var player:Player = body
		if type == types.regen:
			if player.life<player.max_life:
				player.life+=1
		elif type == types.damage:
			player.hit(1)
		elif type == types.inc_max_life:
			if player.max_life<10:
				player.max_life+=1
		elif type == types.inc_ammo:
			player.bag_ammo+=player.gum_pent
			player.ammo_ui.update_ui(player.actual_ammo,player.bag_ammo)
