extends Node2D
signal Start
signal Join
signal Host
@onready var multiplayer_menu = $multiplayer_menu
@onready var main_menu = $main_menu


func _ready():
	multiplayer_menu.hide()
	
func _on_start_pressed():
	emit_signal("Start")

func _on_multiplayer_pressed():
	multiplayer_menu.show()
	main_menu.hide()

func _on_options_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_join_pressed():
	emit_signal("Join")

func _on_host_pressed():
	emit_signal("Host")

func _on_back_pressed():
	main_menu.show()
	multiplayer_menu.hide()
