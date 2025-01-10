extends Area2D

@onready var block:TileMapLayer = %Block
@onready var enter1:Area2D = %EnterRoom
@onready var enter2:Area2D = %EnterRoom2
@onready var enter3:Area2D = %EnterRoom3
@onready var enter4:Area2D = %EnterRoom4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		block.collision_enabled = true
		block.visible = true
		enter1.queue_free()
		enter2.queue_free()
		enter3.queue_free()
		enter4.queue_free()
		get_parent().can_spawn_enemy = true
		get_parent().round_cooldown=2.0
