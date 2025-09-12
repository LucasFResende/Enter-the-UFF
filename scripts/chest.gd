extends StaticBody2D

@onready var ui:Control = $InterectUi
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var open_chest_anim:CanvasLayer = load("res://UI/open_chest.tscn").instantiate()

var player_in:bool = false
var opened:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !opened:
		if player_in and Input.is_action_just_pressed("interact"):
			open()
			anim.play("open")
			get_parent().get_parent().get_parent().get_child(8).get_child(5).add_child(open_chest_anim)
			$Area2D.queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = true
		player_in = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = false
		player_in = false

func open():
	opened = true
	pass
