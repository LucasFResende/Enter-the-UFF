extends HBoxContainer

var heart_full = preload("res://addons/ui/full_heart.png")
var heart_empty = preload("res://addons/ui/empty_heart.png")
var heart_half = preload("res://addons/ui/half_heart.png")
var heart_half_empty = preload("res://addons/ui/half_empty_heart.png")
var heart_half_full = preload("res://addons/ui/half_full_heart.png")

var full_hearts:int
var h:int

func update_health(value:int,max_value:int):
	full_hearts = int(max_value/2)
	for i in range(full_hearts):
		get_child(i).texture = heart_empty
	if full_hearts*2<max_value and full_hearts!=5:
		get_child(full_hearts).texture = heart_half_empty
	
	h = get_hearts(max_value)
	for i in range(1,h+1):
		if i*2<=value:
			get_child(i-1).texture= heart_full
		elif i*2>value and (i-1)*2<value and i*2>max_value:
			get_child(i-1).texture = heart_half_full
		elif i*2>value and (i-1)*2<value:
			get_child(i-1).texture = heart_half
			
func get_hearts(value):
	if value%2==0:
		return int(value/2)
	else:
		return int(value/2)+1
