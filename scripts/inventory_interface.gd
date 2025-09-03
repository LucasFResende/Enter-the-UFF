extends Control

@onready var anim:AnimationPlayer = %AnimationPlayer


var last_button_pressed_id:int = -1
var button_pressed_id:int = -1



func _on_back_button_pressed() -> void:
	anim.play("close")
	await anim.animation_finished
	get_parent().get_child(1).anim.play("close")
	call_deferred("queue_free")


func _on_equip_button_pressed() -> void:
	pass

func _on_equip_button_2_pressed() -> void:
	pass
