class_name Shop
extends Control

@onready var anim:AnimationPlayer = %AnimationPlayer
@onready var HBox1 = %HBoxContainer
@onready var HBox2 = %HBoxContainer2
@onready var HBox3 = %HBoxContainer3
@onready var HBox4 = %HBoxContainer4

@onready var name_show_label:Label = %NameShowLabel
@onready var desc_show_label:Label = %DescriptionShowLabel

var item_selected_price:int
var item_selected_amount:int
var item_selected_number: int
var item_selected_type:int

var shop_items:Array

@onready var HBOXS = [HBox1,HBox2,HBox3,HBox4]

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	anim.play("close")
	await anim.animation_finished
	get_parent().get_child(1).anim.play("close")
	call_deferred("queue_free")


func _on_buy_button_pressed() -> void:
	if player.coins >= item_selected_price and item_selected_amount>0:
		player.coins-=item_selected_price
		ShopItemsList.items[item_selected_number]["quantidade"]-=1
		item_selected_amount-=1
		process_type()
		update_ui()

func update_ui():
	get_parent().get_child(1).coin_label.text = str(player.coins)
	clean_shop_container()
	var count = 1
	for item in ShopItemsList.items:
		var item_shop:ItemShop = load("res://UI/item_shop.tscn").instantiate()
		item_shop.list(item["nome"],item["descrição"],item["custo"],item["icone"],item["quantidade"],count-1,item["tipo"])
		if count <=3:
			HBox1.add_child(item_shop)
		elif count <=6:
			HBox2.add_child(item_shop)
		elif count <=9:
			HBox3.add_child(item_shop)
		elif count <=12:
			HBox4.add_child(item_shop)
		count+=1
		
func clean_shop_container():
	var children: Array[Node]
	for Hbox:HBoxContainer in HBOXS:
		children = Hbox.get_children()
		for child:Node in children:
			Hbox.remove_child(child)
			child.call_deferred("queue_free")

func process_type():
	var selected_item = ShopItemsList.items[item_selected_number]
	if item_selected_type == 0:
		player.flags[selected_item["flag"]]+=1
	elif item_selected_type == 1:
		player.items.append(load(selected_item["item_path"]).instantiate())
