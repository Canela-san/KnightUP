extends Node2D
signal AddPoint
signal Reset_Level
signal win
var master_manager = 0
const win_window_Path = "res://Scenes/Win Window.tscn"
func _ready():
	pass
func initialize(game_state):
	# Configure o nível com base no estado do jogo
	if game_state.has("score"):
		print("Carregando estado do jogo: ", game_state["score"])
		
func _on_level_maneger_coin_picked():
	emit_signal("AddPoint")
	#get_parent().NextLevel()
func _on_level_maneger_reset():
	emit_signal("Reset_Level")

func _on_killzone_death():
	emit_signal("Reset_Level")

func _on_area_2d_body_entered(_body):
	if !has_node("win"):
		var win = ResourceLoader.load(win_window_Path)
		if win:
			var win_window = win.instantiate()
			add_child(win_window)
			win_window.name = "win"
			if win_window.has_method("initialize"):
				win_window.initialize()
	
