extends CanvasLayer

@onready var color_picker:ColorPicker = $ColorPicker
@onready var player_visual:Sprite2D = $Container/Sprite2D

var default_color_hair:Color = Color(0, 0, 0)
var default_color_shirt:Color = Color(0.067, 0.067, 0.075)
var default_color_emblem:Color = Color(0.416, 0.745, 0.188)
var default_color_short:Color = Color(0.224, 0.31, 0.471)

var change_item:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if change_item == "hair":
		player_visual.material.set("shader_parameter/hair_replace_color",color_picker.color)
		GameManager.player_custom_hair = color_picker.color
	if change_item == "shirt":
		player_visual.material.set("shader_parameter/shirt_replace_color",color_picker.color)
		GameManager.player_custom_shirt = color_picker.color
	if change_item == "emblem":
		player_visual.material.set("shader_parameter/emblem_replace_color",color_picker.color)
		GameManager.player_custom_emblem = color_picker.color
	if change_item == "short":
		player_visual.material.set("shader_parameter/shorts_replace_color",color_picker.color)
		GameManager.player_custom_short = color_picker.color




func _on_hair_button_pressed() -> void:
	change_item = "hair"
	color_picker.color = player_visual.material.get("shader_parameter/hair_replace_color")

func _on_shirt_button_pressed() -> void:
	change_item = "shirt"
	color_picker.color = player_visual.material.get("shader_parameter/shirt_replace_color")

func _on_emblem_button_pressed() -> void:
	change_item = "emblem"
	color_picker.color = player_visual.material.get("shader_parameter/emblem_replace_color")

func _on_short_button_pressed() -> void:
	change_item = "short"
	color_picker.color = player_visual.material.get("shader_parameter/shorts_replace_color")

func _on_reset_button_pressed() -> void:
	player_visual.material.set("shader_parameter/hair_replace_color",default_color_hair)
	player_visual.material.set("shader_parameter/shirt_replace_color",default_color_shirt)
	player_visual.material.set("shader_parameter/emblem_replace_color",default_color_emblem)
	player_visual.material.set("shader_parameter/shorts_replace_color",default_color_short)
	GameManager.player_custom_hair = default_color_hair
	GameManager.player_custom_shirt = default_color_shirt
	GameManager.player_custom_emblem = default_color_emblem
	GameManager.player_custom_short = default_color_short

func _on_back_button_pressed() -> void:
	var ui:CanvasLayer = get_parent().get_child(1)
	ui.visible = true
	ui.process_mode = Node.PROCESS_MODE_INHERIT
	call_deferred("queue_free")
