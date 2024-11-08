extends CanvasLayer

func update_ui(actual_ammo:int, bag_ammo:int)->void:
	$Label.text = str(actual_ammo)+"/"+str(bag_ammo)
