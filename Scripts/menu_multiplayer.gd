extends Node2D
signal Join_Multiplayer
signal Host_Multiplayer

func _on_connect_pressed():
	emit_signal("Join_Multiplayer")
	pass # Replace with function body.

func _on_host_pressed():
	emit_signal("Host_Multiplayer")
	pass # Replace with function body.

func _on_back_pressed():
	self.queue_free()
	pass # Replace with function body.
