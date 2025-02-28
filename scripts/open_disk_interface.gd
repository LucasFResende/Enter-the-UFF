extends Control

@onready var anim:AnimationPlayer = %AnimationPlayer
@onready var label:Label = %Label
@onready var rarity_panel:TextureRect = %RarityPanel
@onready var gun_icon:Sprite2D = %GunIcon
@onready var star:Sprite2D = %Star

var last_button_pressed_id:int = -1
var button_pressed_id:int = -1

var label_delta:float = 99
var is_opening:bool = false


@onready var buttons:Array[Button] = [
%Button, %Button2, %Button3, %Button4, %Button5, %Button6,
%Button7, %Button8, %Button9, %Button10, %Button11, %Button12,
%Button13, %Button14, %Button15, %Button16, %Button17, %Button18,
%Button19, %Button20, %Button21, %Button22, %Button23, %Button24,
%Button25, %Button26, %Button27, %Button28, %Button29, %Button30,
%Button31, %Button32, %Button33, %Button34, %Button35, %Button36,
%Button37, %Button38, %Button39, %Button40, %Button41, %Button42,
%Button43, %Button44, %Button45, %Button46, %Button47, %Button48,
%Button49, %Button50, %Button51, %Button52, %Button53, %Button54,
%Button55, %Button56, %Button57, %Button58, %Button59, %Button60]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_items_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if button_pressed_id != last_button_pressed_id:
		buttons[button_pressed_id].get_child(1).visible = false


func _on_back_button_pressed() -> void:
	anim.play("close")
	await anim.animation_finished
	get_parent().get_child(1).anim.play("close")
	call_deferred("queue_free")

func _on_open_button_pressed() -> void:
	if player.items[button_pressed_id].is_in_group("Item"):
		buttons[button_pressed_id].get_child(1).visible= false
		var item:Item = player.items[button_pressed_id]
		player.items.remove_at(button_pressed_id)
		var loot = item.open()
		var coins:int = loot[0]
		var gun:Gun = loot[1]
		player.coins+= coins
		%Label.text = "+"+str(coins)
		if loot[1]!=null:
			anim.play("open_item")
			player.items.append(gun)
			gun_icon.texture = gun.icon
			rarity_panel.texture = gun.panel
			star.modulate = gun.rarity_color
		else:
			anim.play("open_item_without_gun")
		item.queue_free()
		button_pressed_id=-1
		last_button_pressed_id=-1
	

func update_items_menu():
	get_parent().get_child(1).coin_label.text = str(player.coins)
	for x in range(player.items.size()):
		if player.items[x].is_in_group("Gun"):
			var gun:Gun = player.items[x]
			if gun==player.gun_1 or gun==player.gun_2:
				buttons[x].get_child(1).texture = gun.equiped_panel
			else:
				buttons[x].get_child(1).texture = gun.inv_panel
			buttons[x].get_child(1).visible = true
			buttons[x].disabled = true
		buttons[x].get_child(0).texture = player.items[x].icon
	for x in range(player.items.size(),60):
		buttons[x].disabled = true
		buttons[x].get_child(0).texture = null
