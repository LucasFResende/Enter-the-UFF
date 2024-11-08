extends Area2D

enum tipos {regen,damage,inc_max_life,inc_ammo}

@export var tipo : tipos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		var player:Player = body
		print("Entrou")
		if tipo == tipos.regen:
			if player.life<player.max_life:
				player.life+=1
		elif tipo == tipos.damage:
			player.hit(1)
		elif tipo == tipos.inc_max_life:
			if player.max_life<10:
				player.max_life+=1
		elif tipo == tipos.inc_ammo:
			player.bag_ammo+=player.gum_pent
			player.ammo_ui.update_ui(player.actual_ammo,player.bag_ammo)
