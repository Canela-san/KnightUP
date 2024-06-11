extends Node
signal CoinPicked
signal Reset

func add_point():
	emit_signal("CoinPicked")
	
func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		if Engine.time_scale == 1:
			Engine.time_scale = 0
		elif Engine.time_scale == 0:
			Engine.time_scale = 1
	if Input.is_action_just_pressed("reset"):
		emit_signal("Reset")
	
func death():
	emit_signal("Reset")
