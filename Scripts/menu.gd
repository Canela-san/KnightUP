extends Node2D
signal Start
signal Menu_Multiplayer
signal Options
signal Quit
#Start Button
func _on_start_pressed():
	emit_signal("Start")
#Options

func _on_multiplayer_pressed():
	emit_signal("Menu_Multiplayer")

func _on_options_pressed():
	emit_signal("Options")

#Quit Button
func _on_quit_pressed():
	emit_signal("Quit")



