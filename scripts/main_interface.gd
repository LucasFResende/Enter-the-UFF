extends Control

@onready var anim:AnimationPlayer = %AnimationPlayer
var inv_interface:PackedScene = load("res://UI/inventory_interface.tscn")
var shop_interface:PackedScene = load("res://UI/shop_interface.tscn")
var customize_interface:PackedScene = load("res://UI/customize_interface.tscn")
@onready var coin_label:Label = %CoinLabel
@onready var coin_icon:Panel = %CoinIcon
@onready var player_icon:AnimatedSprite2D = %PlayerIcon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_label.text = str(player.coins)
	player_icon.material.set("shader_parameter/hair_replace_color",player.material.get("shader_parameter/hair_replace_color"))
	player_icon.material.set("shader_parameter/shirt_replace_color",player.material.get("shader_parameter/shirt_replace_color"))
	player_icon.material.set("shader_parameter/emblem_replace_color",player.material.get("shader_parameter/emblem_replace_color"))
	player_icon.material.set("shader_parameter/shorts_replace_color",player.material.get("shader_parameter/shorts_replace_color"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_inventory_button_pressed() -> void:
	open(inv_interface)


func _on_shop_button_pressed() -> void:
	open(shop_interface)

func _on_customize_button_pressed() -> void:
	open(customize_interface)

func open(scene:PackedScene):
	anim.play("open")
	await anim.animation_finished
	add_sibling(scene.instantiate())


func _on_quit_button_pressed() -> void:
	get_parent().get_parent().get_child(0).get_child(1).play("pc_off")
	player.is_in_pc = false
	GameManager.is_in_menu = false
	GameManager.change_mouse()
	player.check_flags()
	get_parent().call_deferred("queue_free")
	
