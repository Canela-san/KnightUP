extends Node2D
signal AddPoint
signal Reset_Level
var master_manager = 0

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
