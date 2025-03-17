extends CanvasLayer

@onready var gun_sprite_label:Sprite2D = %GunSlot

@onready var grenade_slot1:Sprite2D = %GrenadeSlot1
@onready var grenade_slot2:Sprite2D = %GrenadeSlot2
@onready var grenade_slot3:Sprite2D = %GrenadeSlot3
@onready var panel:Panel = %Panel

var grenade_icon:Texture = load("res://addons/guns/grenade_icon.png")
var empty_grenade_icon:Texture = load("res://addons/guns/empty_grenade_icon.png")

func update_gun_ui(actual_ammo:int, bag_ammo:int,gun_sprite:Texture2D,color:Color)->void:
	$Control/Label.text = str(actual_ammo)+"/"+str(bag_ammo)
	gun_sprite_label.texture = gun_sprite
	panel.self_modulate = color

func update_grenade_ui(actual_grenades:int)->void:
	if actual_grenades == 3:
		grenade_slot1.texture = grenade_icon
		grenade_slot2.texture = grenade_icon
		grenade_slot3.texture = grenade_icon
	if actual_grenades == 2:
		grenade_slot1.texture = empty_grenade_icon
		grenade_slot2.texture = grenade_icon
		grenade_slot3.texture = grenade_icon
	if actual_grenades == 1:
		grenade_slot1.texture = empty_grenade_icon
		grenade_slot2.texture = empty_grenade_icon
		grenade_slot3.texture = grenade_icon
	if actual_grenades == 0:
		grenade_slot1.texture = empty_grenade_icon
		grenade_slot2.texture = empty_grenade_icon
		grenade_slot3.texture = empty_grenade_icon
