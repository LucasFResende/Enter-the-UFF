extends Node

@onready var table_name:String = get_node(".").name
var is_turnable:bool = true

const UP:Vector2 = Vector2(0,-1)
const DOWN:Vector2 = Vector2(0,1)
const LEFT:Vector2 = Vector2(1,0)
const RIGHT:Vector2 = Vector2(-1,0)

signal flip
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_flip(direction) -> void:
	if table_name == "HorizontalTable" and is_turnable:
		if direction == DOWN:
			is_turnable = false
			$AnimatedSprite2D.play("flip_back")
		elif direction == UP:
			is_turnable = false
			$AnimatedSprite2D.play("flip_front")
	elif table_name == "VerticalTable" and is_turnable:
		if direction == LEFT:
			is_turnable = false
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("default")
		elif direction == RIGHT:
			is_turnable = false
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("default")
