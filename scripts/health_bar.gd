extends CanvasLayer

var heart_full = preload("res://addons/ui/full_heart.png")
var heart_empty = preload("res://addons/ui/empty_heart.png")
var heart_half = preload("res://addons/ui/half_heart.png")
var heart_half_empty = preload("res://addons/ui/half_empty_heart.png")
var heart_half_full = preload("res://addons/ui/half_full_heart.png")

var shield_full = preload("res://addons/ui/full_shield.png")
var shield_empty = preload("res://addons/ui/empty_shield.png")
var shield_half = preload("res://addons/ui/half_shield.png")
var shield_half_empty = preload("res://addons/ui/half_empty_shield.png")
var shield_half_full = preload("res://addons/ui/half_full_shield.png")

@onready var Health:HBoxContainer = %Health
@onready var Shield:HBoxContainer = %Shield
@onready var Stamina:ProgressBar = %Stamina

var full_hearts:int
var full_shields:int
var h:int

func update_ui(health_value:int,health_max_value:int,shield_value:int,shield_max_value:int,stamina_value:int,stamina_max_value:int):
	analize_health(health_value,health_max_value)
	analize_shield(shield_value,shield_max_value)
	analize_stamina(stamina_value,stamina_max_value)

func analize_health(value:int, max_value:int):
	full_hearts = int(max_value/2)
	for i in range(full_hearts):
		Health.get_child(i).texture = heart_empty
	if full_hearts*2<max_value and full_hearts!=8:
		Health.get_child(full_hearts).texture = heart_half_empty
	h = get_hearts(max_value)
	for i in range(1,h+1):
		if i*2<=value:
			Health.get_child(i-1).texture= heart_full
		elif i*2>value and (i-1)*2<value and i*2>max_value:
			Health.get_child(i-1).texture = heart_half_full
		elif i*2>value and (i-1)*2<value:
			Health.get_child(i-1).texture = heart_half
	
func analize_shield(value:int, max_value:int):
	full_shields = int(max_value/2)
	for i in range(full_shields):
		Shield.get_child(i).texture = shield_empty
	if full_shields*2<max_value and full_shields!=5:
		Shield.get_child(full_shields).texture = shield_half_empty
	
	h = get_shield(max_value)
	for i in range(1,h+1):
		if i*2<=value:
			Shield.get_child(i-1).texture= shield_full
		elif i*2>value and (i-1)*2<value and i*2>max_value:
			Shield.get_child(i-1).texture = shield_half_full
		elif i*2>value and (i-1)*2<value:
			Shield.get_child(i-1).texture = shield_half

func analize_stamina(value:int,max_value:int):
	Stamina.max_value = max_value
	Stamina.value = value

func get_hearts(value):
	if value%2==0:
		return int(value/2)
	else:
		return int(value/2)+1
		
func get_shield(value):
	if value%2==0:
		return int(value/2)
	else:
		return int(value/2)+1
