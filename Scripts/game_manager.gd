extends Node
const SERVER_PORT = 12345
const SERVER_IP = "192.168.15.42"
#const SERVER_IP = "127.0.0.1"
const lvlQuant = 2
var new_level_path = 0
var game_state = {"score": 0}
var current_level = 1
var coin = 0
var PlayerPath = "res://Scenes/player.tscn"

@onready var music_menu = $"Music Manager/Music Menu"
@onready var music_game = $"Music Manager/Music_game"
@onready var menu = $Menu

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene


func _ready():
	music_menu.play()

func getLevelPath(level):
	return "res://Scenes/lvl"+ str(level) +".tscn"
	
func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		menu.show()
		if has_node("Current_Level"):
			get_node("Current_Level").queue_free()
		if has_node("Current_Level2"):
			get_node("Current_Level2").queue_free()


func LoadLevel(level):

	if has_node("Current_Level"):
		get_node("Current_Level").queue_free()
	if has_node("Current_Level2"):
		get_node("Current_Level2").queue_free()
		
	# Carrega o novo nível
	var new_level_resource = ResourceLoader.load(getLevelPath(level))
	if new_level_resource:
		var new_level = new_level_resource.instantiate()
		add_child(new_level)
		new_level.name = "Current_Level"
		if new_level.has_method("initialize"):
			new_level.initialize(game_state)
		new_level.connect("AddPoint", self._on_lvl_1_add_point)
		new_level.connect("Reset_Level", self.reset_level)
		
func create_player():
	if has_node("Player"):
		get_node("Player").queue_free()
		
	# Carrega o novo nível
	var new_player = ResourceLoader.load(PlayerPath)
	if new_player:
		var player = new_player.instantiate()
		add_child(player)
		player.name = "Player"
		if player.has_method("initialize"):
			player.initialize()

func _on_lvl_1_add_point():
	game_state["score"] += 1
	print(game_state["score"])
	if game_state["score"] == coin:
		LoadLevel(++current_level)
		
func reset_level():
	Engine.time_scale = 1
	#LoadLevel(current_level)
	

func _on_menu_start():
	music_menu.stop()
	music_game.play()
	menu.hide()
	LoadLevel(current_level)
	create_player()

func _on_menu_join():
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	print("conecting !")

func _on_menu_host():
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_connected.disconnect(_del_player)
	_on_menu_start()
	print("hosting !")
	#_add_player()

func _add_player(id: int):
	print("player %s joined" % id)
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func _del_player(_id: int):
	pass
