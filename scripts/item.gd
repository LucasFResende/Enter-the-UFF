extends Sprite2D
class_name Item

var player_in:bool = false
var player:Player

@onready var ui:Control = $InterectUi
@onready var anim:AnimationPlayer = $AnimationPlayer

enum item_types {pendrive, hd, ssd, nvme}

@export var item_type:item_types
@onready var name_type:String = def_type_name()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in and Input.is_action_just_pressed("interact"):
		get_parent().item_collected = true
		if name_type not in player.items.keys():
			player.items[name_type] = 0
		player.items[name_type] +=1
		call_deferred("queue_free")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = true
		player = body
		player_in = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = false
		player_in = false

func def_type_name() -> String:
	if item_type == item_types.pendrive:
		return "pendrive"
	elif item_type == item_types.hd:
		return "hd"
	elif item_type == item_types.ssd:
		return "ssd"
	elif item_type == item_types.nvme:
		return "nvme"
	return ""
