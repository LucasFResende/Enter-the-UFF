class_name ItemShop
extends Control

@onready var icon:Sprite2D = %Icon
@onready var item_name_label:Label = %NameLabel
@onready var price_label:Label = %PriceLabel
@onready var amount_label:Label = %AmountLabel

var item_name: String
var item_description:String
var item_price: int
var item_icon:Texture
var item_amount:int
var number:int


func _ready() -> void:
	item_name_label.text = item_name
	price_label.text = str(item_price)
	icon.texture = item_icon
	amount_label.text = str(item_amount)
	

func list(_name:String, description:String, price:String, icon_path:String, amount:int,count:int):
	item_name = _name
	item_description = description
	item_price = int(price)
	item_icon = load(icon_path)
	item_amount = amount
	number = count


func _on_button_pressed() -> void:
	var shop:Shop = get_parent().get_parent().get_parent().get_parent()
	shop.name_show_label.text = item_name
	shop.desc_show_label.text = item_description
	shop.item_selected_price = item_price
	shop.item_selected_amount = item_amount
	shop.item_selected_number = number
