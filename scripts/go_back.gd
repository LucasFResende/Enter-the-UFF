extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)



func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.local = "UFF"
		save_player_infos(body)
		body.change_scene.change_scene(GameManager.return_scene_path,GameManager.return_local)

func save_player_infos(body:Player):
	GameManager.player_items = body.items
	GameManager.player_actual_ammo = body.actual_ammo
	GameManager.player_bag_ammo = body.bag_ammo
	GameManager.player_life = body.life
