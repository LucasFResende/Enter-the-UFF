extends Area2D

var anim:AnimationPlayer
var is_in_area:bool = false
var player:Player
@onready var pc_interface:PackedScene = load("res://UI/pc_interface.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and is_in_area:
		player.gun_spawner.process_mode = Node.PROCESS_MODE_DISABLED
		player.gun_spawner.get_child(0).visible = false
		player.gun_spawner.get_child(1).visible = false
		GameManager.is_in_menu = true
		GameManager.change_mouse()
		anim.play("pc_on")
		await anim.animation_finished
		player.get_child(5).add_child(pc_interface.instantiate())


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		anim = player.get_child(5).get_child(0).get_child(1)
		anim.play("interact")
		is_in_area = true
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		anim.play("no_interact")
		is_in_area = false
