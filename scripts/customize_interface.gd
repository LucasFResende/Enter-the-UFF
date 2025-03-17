extends Control

@onready var color_picker:ColorPicker = $ColorPicker
@onready var sprite:AnimatedSprite2D = get_parent().get_child(1).get_child(0).get_child(1).get_child(0)
@onready var anim:AnimationPlayer = $AnimationPlayer

var saved_hair_color:Color
var saved_shirt_color:Color
var saved_emblem_color:Color
var saved_short_color:Color
var actual_hair_color:Color
var actual_shirt_color:Color
var actual_emblem_color:Color
var actual_short_color:Color

var is_changing:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_child(1).coin_label.visible = false
	get_parent().get_child(1).coin_icon.visible = false
	saved_hair_color = player.hair_color
	actual_hair_color = player.hair_color
	saved_shirt_color = player.shirt_color
	actual_shirt_color = player.shirt_color
	saved_emblem_color = player.emblem_color
	actual_emblem_color = player.emblem_color
	saved_short_color = player.short_color
	actual_short_color = player.short_color
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_changing == "hair":
		sprite.material.set("shader_parameter/hair_replace_color",color_picker.color)
		actual_hair_color = color_picker.color
	if is_changing == "shirt":
		sprite.material.set("shader_parameter/shirt_replace_color",color_picker.color)
		actual_shirt_color = color_picker.color
	if is_changing == "emblem":
		sprite.material.set("shader_parameter/emblem_replace_color",color_picker.color)
		actual_emblem_color = color_picker.color
	if is_changing == "short":
		sprite.material.set("shader_parameter/shorts_replace_color",color_picker.color)
		actual_short_color = color_picker.color


func _on_hair_button_pressed() -> void:
	is_changing = "hair"
	color_picker.color = actual_hair_color
	


func _on_shirt_button_pressed() -> void:
	is_changing = "shirt"
	color_picker.color = actual_shirt_color


func _on_emblem_button_pressed() -> void:
	is_changing = "emblem"
	color_picker.color = actual_emblem_color


func _on_short_button_pressed() -> void:
	is_changing = "short"
	color_picker.color = actual_short_color


func _on_reset_button_pressed() -> void:
	actual_hair_color = saved_hair_color
	actual_shirt_color = saved_shirt_color
	actual_emblem_color = saved_emblem_color
	actual_short_color = saved_short_color
	sprite.material.set("shader_parameter/hair_replace_color",saved_hair_color)
	sprite.material.set("shader_parameter/shirt_replace_color",saved_shirt_color)
	sprite.material.set("shader_parameter/emblem_replace_color",saved_emblem_color)
	sprite.material.set("shader_parameter/shorts_replace_color",saved_short_color)
	if is_changing == "hair":
		color_picker.color = saved_hair_color
	if is_changing == "shirt":
		color_picker.color = saved_shirt_color
	if is_changing == "emblem":
		color_picker.color = saved_emblem_color
	if is_changing == "short":
		color_picker.color = saved_short_color


func _on_save_button_pressed() -> void:
	saved_hair_color = actual_hair_color
	saved_shirt_color = actual_shirt_color
	saved_emblem_color = actual_emblem_color
	saved_short_color = actual_short_color


func _on_back_button_pressed() -> void:
	_on_reset_button_pressed()
	player.material.set("shader_parameter/hair_replace_color",saved_hair_color)
	player.material.set("shader_parameter/shirt_replace_color",saved_shirt_color)
	player.material.set("shader_parameter/emblem_replace_color",saved_emblem_color)
	player.material.set("shader_parameter/shorts_replace_color",saved_short_color)
	player.hair_color = saved_hair_color
	player.shirt_color = saved_shirt_color
	player.emblem_color = saved_emblem_color
	player.short_color = saved_short_color
	
	anim.play("close")
	await anim.animation_finished
	get_parent().get_child(1).coin_label.visible = true
	get_parent().get_child(1).coin_icon.visible = true
	get_parent().get_child(1).anim.play("close")
	call_deferred("queue_free")
