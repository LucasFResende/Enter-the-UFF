extends StaticBody2D

@onready var ui:Control = $InterectUi
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D

@export var drops:Array[PackedScene]

var player_in:bool = false
var drop:Item
var dropped:bool = false
var item_collected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !item_collected:
		if player_in and Input.is_action_just_pressed("interact"):
			open()
			anim.play("open")
			$Area2D.queue_free()
		if dropped and drop.global_position.y>global_position.y-13:
			drop.position.y-=.25
			return



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = true
		player_in = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ui.visible = false
		player_in = false

func open():
	dropped = true
	var chance = randf()
	if chance<=0.5:
		drop = drops[0].instantiate()
	elif chance>0.5 and chance<=0.7:
		drop = drops[1].instantiate()
	elif chance>0.7 and chance<=0.9:
		drop = drops[2].instantiate()
	elif chance>0.9:
		drop = drops[3].instantiate()
	add_child(drop)
