extends Area2D

@export var path_to_scene:String
@export var return_position:Vector2
@export var local_to_go:String
@export var enemies_room_arrays:Array[PackedScene]
@export var floor:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)



func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		GameManager.local = local_to_go
		GameManager.enimeis_array = enemies_room_arrays
		GameManager.return_local = return_position
		if floor==1:
			GameManager.return_scene_path = "res://map/uff_floor1.tscn"
		elif floor==2:
			GameManager.return_scene_path = "res://map/uff_floor2.tscn"
		body.change_scene.change_scene(path_to_scene,Vector2.ZERO)
