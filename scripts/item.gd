extends Sprite2D
class_name Item

var player_in:bool = false


@onready var ui:Control = $InterectUi
@onready var anim:AnimationPlayer = $AnimationPlayer

enum item_types {pendrive, hd, ssd, nvme}

@export var item_type:item_types

@export var icon:Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in and Input.is_action_just_pressed("interact"):
		get_parent().item_collected = true
		player.items.append(get_type())
		call_deferred("queue_free")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = true
		player_in = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = false
		player_in = false

	
func get_type():
	if item_type == item_types.pendrive:
		return load("res://objects/itens/pendrive.tscn")
	elif item_type == item_types.hd:
		return load("res://objects/itens/hd.tscn")
	elif item_type == item_types.ssd:
		return load("res://objects/itens/ssd.tscn")
	elif item_type == item_types.nvme:
		return load("res://objects/itens/nvme.tscn")
