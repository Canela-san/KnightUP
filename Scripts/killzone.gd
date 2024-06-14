extends Area2D

@onready var timer = $Timer
var player = 0
signal death

func _on_body_entered(body):
	player = body
	Engine.time_scale = 0.5
	body.get_node("AnimatedSprite2D").play("death")
	#body.get_node("AudioStreamPlayer2D").play()
	timer.start()
	
func _on_timer_timeout():
	Engine.time_scale = 1
	emit_signal("death")
	player.position = Vector2i(0,0)
	
