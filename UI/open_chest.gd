extends CanvasLayer

func _ready() -> void:
	var coins = randi_range(1,30)
	$Label.text = "+"+str(coins)
	player.coins+=coins

func _process(delta: float) -> void:
	print($Timer.time_left)
	if $Timer.time_left == 0:
		call_deferred("queue_free")
