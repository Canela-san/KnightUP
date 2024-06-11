extends Node2D
signal AddPoint
signal Reset_Level
var master_manager = 0
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

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
	
func Multiplayer_Host():
	peer.create_server(12345)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
func _on_join_pressed():
	peer.create_client("192.168.15.42", 12345)
	multiplayer.multiplayer_peer = peer
