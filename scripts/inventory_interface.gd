extends Control

@onready var anim:AnimationPlayer = %AnimationPlayer
@onready var gun1_esquiped_sprite:Sprite2D = %GunEquiped1
@onready var gun2_esquiped_sprite:Sprite2D = %GunEquiped2
@onready var gun1:Control = %Gun1
@onready var gun2:Control = %Gun2
@onready var coin_label:Label = %CoinLabel
@onready var coin_icon:Panel = %CoinIcon


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

var last_button_pressed_id:int = -1
var button_pressed_id:int = -1

var gun1_button_id:int
var gun2_button_id:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_items_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	anim.play("close")
	await anim.animation_finished
	get_parent().get_child(1).anim.play("close")
	call_deferred("queue_free")


func _on_equip_button_pressed() -> void:
	if player.items[button_pressed_id].is_in_group("Gun"):
			var gun:Gun = player.items[button_pressed_id]
			player.gun_1 = gun
			gun.visible = false
			if player.num_gun_actual==1:
				player.gun_actual = gun
			gun1_button_id = button_pressed_id
			var spaw = player.gun_spawner
			spaw.remove_child(spaw.get_child(0))
			spaw.add_child(gun)
			spaw.move_child(spaw.get_child(1),0)
			update_items_menu()
			buttons[button_pressed_id].get_child(1).visible = false

func _on_equip_button_2_pressed() -> void:
	if player.items[button_pressed_id].is_in_group("Gun") :
			var gun:Gun = player.items[button_pressed_id]
			player.gun_2 = gun
			gun.visible = false
			if player.num_gun_actual==2:
				player.gun_actual = gun
			gun2_button_id = button_pressed_id
			var spaw = player.gun_spawner
			spaw.remove_child(spaw.get_child(1))
			spaw.add_child(gun)
			update_items_menu()
			buttons[button_pressed_id].get_child(1).visible = false

func _on_sell_button_pressed() -> void:
	if player.items[button_pressed_id].is_in_group("Gun"):
		buttons[button_pressed_id].get_child(1).visible= false
		var gun:Gun = player.items[button_pressed_id]
		player.items.remove_at(button_pressed_id)
		player.coins+=gun.sell_price
		gun.queue_free()
		update_items_menu()

func update_items_menu():
	coin_icon.visible = false
	coin_label.visible = false
	get_parent().get_child(1).coin_label.text = str(player.coins)
	if GameManager.player_gun_1 != null:
		gun1_esquiped_sprite.texture = player.gun_1.icon
		gun1.get_child(1).texture = player.gun_1.inv_panel
	if GameManager.player_gun_2!= null:
		gun2_esquiped_sprite.texture = player.gun_2.icon
		gun2.get_child(1).texture = player.gun_2.inv_panel
	for x in range(player.items.size()):
		buttons[x].disabled = false
		buttons[x].get_child(0).texture = player.items[x].icon
		if player.items[x].is_in_group("Item"):
			buttons[x].get_child(2).visible = false
			buttons[x].disabled = true
		if player.items[x].is_in_group("Gun") and player.items[x] != player.gun_1 and player.items[x] != player.gun_2:
			buttons[x].get_child(2).texture = player.items[x].inv_panel
			buttons[x].get_child(2).visible = true
		elif player.items[x] == player.gun_1:
			gun1_button_id = x
			buttons[x].get_child(2).visible = true
			buttons[x].disabled = true
			buttons[x].get_child(2).texture = player.items[x].equiped_panel
		elif player.items[x] == player.gun_2:
			gun2_button_id = x
			buttons[x].get_child(2).visible = true
			buttons[x].disabled = true
			buttons[x].get_child(2).texture = player.items[x].equiped_panel
	for x in range(player.items.size(),60):
		buttons[x].disabled = true
		buttons[x].get_child(0).texture = null
