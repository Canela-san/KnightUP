extends Node
const SERVER_PORT:int = 12345
const SERVER_IP:String = "192.168.15.42"
#const SERVER_IP:String = "127.0.0.1"
const lvlQuant:int = 2
const PlayerPath:String = "res://Scenes/player_solo.tscn"

var new_level_path:String = ""
var game_state:Dictionary = {"score": 0}
var current_level:int = 1
var coin:int = 0
var peer = ENetMultiplayerPeer.new()

@onready var music_menu:Node = $"Music Manager/Music Menu"
@onready var music_game:Node = $"Music Manager/Music_game"
@onready var menu:Node = $Menu
@onready var _player_spawn_node:Node = $Players
@onready var map = $Map
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

func win():
	pass

func LoadLevel(level):
	
	if has_node("Current_Level"):
		get_node("Current_Level").queue_free()
	if has_node("Current_Level2"):
		get_node("Current_Level2").queue_free()
		
	# Carrega o novo nível
	var new_level_resource = ResourceLoader.load(getLevelPath(level))
	if new_level_resource:
		var new_level = new_level_resource.instantiate()
		map.add_child(new_level)
		new_level.name = "Current_Level"
		if new_level.has_method("initialize"):
			new_level.initialize(game_state)
		new_level.connect("AddPoint", self._on_lvl_1_add_point)
		new_level.connect("Reset_Level", self.reset_level)
		new_level.connect("win", self.win)

func create_player():

	# Carrega o novo nível
	var new_player = ResourceLoader.load(PlayerPath)
	if new_player:
		var player = new_player.instantiate()
		_player_spawn_node.add_child(player)
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

func _on_menu_start(is_multiplayer:bool = 0):
	music_menu.stop()
	music_game.play()
	menu.hide()
	LoadLevel(current_level)
	if !is_multiplayer:
		create_player()

func _on_menu_join():
	_on_menu_start(1)
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	print("conecting !")

func _on_menu_host():
	_on_menu_start(1)
	
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_del_player)
	print("hosting !")
	_add_player(1)

func _add_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.player_id = id
	_player_spawn_node.add_child(player, true)
	print(_player_spawn_node.get_node(str(id)).player_id)
	print("player %s joined" % id)
	player.printt()

func _del_player(id: int):
	print("player %s left the game" % id)
	if _player_spawn_node.has_node(str(id)):
		_player_spawn_node.get_node(str(id)).queue_free()
