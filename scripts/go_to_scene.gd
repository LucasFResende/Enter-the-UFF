extends Area2D

@export var path_to_scene:String
@export var set_position:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.



func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.change_scene.change_scene(path_to_scene,set_position)
