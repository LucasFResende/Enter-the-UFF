extends Area2D

@export var path_to_scene:String
@export var position_stairs:Vector2
@export var local_to_go:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)



func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.local = local_to_go
		GameManager.staris = position_stairs
		save_player_infos(body)
		body.change_scene.change_scene(path_to_scene,position_stairs)

func save_player_infos(body:Player):
	GameManager.player_items = body.items
	GameManager.player_actual_ammo = body.actual_ammo
	GameManager.player_bag_ammo = body.bag_ammo
	GameManager.player_life = body.life