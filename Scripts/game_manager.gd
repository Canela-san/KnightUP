extends Node

const lvlQuant = 2
var new_level_path = 0
var game_state = {"score": 0}
var level = 0
var coin = 0



func _ready():
	Menu()
	Music_Menu()

func Menu():
	var menu = ResourceLoader.load("res://Scenes/menu.tscn")
	if menu:
		var Imenu = menu.instantiate()
		add_child(Imenu)
		Imenu.name = "menu"
		if Imenu.has_method("initialize"):
			Imenu.initialize(game_state)
		Imenu.connect("Start", self._on_control_start)
		Imenu.connect("Menu_Multiplayer", self.Menu_Multiplayer)
		Imenu.connect("Options", self._on_control_options)
		Imenu.connect("Quit", self._on_control_quit)

func Menu_Multiplayer():
	var menu_Multipleyer = ResourceLoader.load("res://Scenes/menu_multiplayer.tscn")
	if menu_Multipleyer:
		var Imenu_Multipleyer = menu_Multipleyer.instantiate()
		add_child(Imenu_Multipleyer)
		Imenu_Multipleyer.name = "menu_Multipleyer"
		if Imenu_Multipleyer.has_method("initialize"):
			Imenu_Multipleyer.initialize(game_state)
		Imenu_Multipleyer.connect("Join_Multiplayer", self._on_Multiplayer_Join_Multiplayer)
		Imenu_Multipleyer.connect("Host_Multiplayer", self._on_Multiplayer_Host_Multiplayer)

func Music_Game():
	var path = ResourceLoader.load("res://Scenes/music2.tscn")
	if path:
		if !has_node("music"):
			var music = path.instantiate()
			add_child(music)
			music.name = "music"
			if music.has_method("initialize"):
				music.initialize(game_state)
			music.play()

func Music_Menu():
	var path = ResourceLoader.load("res://Scenes/Music_Menu.tscn")
	if path:
		if !has_node("Music_Menu"):
			var music = path.instantiate()
			add_child(music)
			music.name = "Music_Menu"
			if music.has_method("initialize"):
				music.initialize(game_state)
			music.play()

func NextLevel():
	if level < lvlQuant:
		level += 1
	new_level_path = "res://Scenes/lvl"+ str(level) +".tscn"
	
	# Remove o nível atual
	if has_node("Current_Level"):
		get_node("Current_Level").queue_free()
	if has_node("Current_Level2"):
		get_node("Current_Level2").queue_free()
		# Espera até que o nó seja realmente removido
			#await get_tree().process_frame
	# Carrega o novo nível
	var new_level_resource = ResourceLoader.load(new_level_path)
	if new_level_resource:
		var new_level = new_level_resource.instantiate()
		add_child(new_level)
		new_level.name = "Current_Level"
		if new_level.has_method("initialize"):
			new_level.initialize(game_state)
		new_level.connect("AddPoint", self._on_lvl_1_add_point)
		new_level.connect("Reset_Level", self.reset_level)
	else:
		pass

func _on_lvl_1_add_point():
	game_state["score"] += 1
	print(game_state["score"])
	if game_state["score"] == coin:
		NextLevel()
		
func reset_level():
	Engine.time_scale = 1
	level -= 1
	NextLevel()

func _on_control_start():
	$menu.queue_free()
	$Music_Menu.queue_free()
	Music_Game()
	NextLevel()

func _on_control_options():
	pass

func _on_control_quit():
	get_tree().quit()
	
func _on_Multiplayer_Join_Multiplayer():
	#var peer = ENetMultiplayerPeer.new()
	pass
	
func _on_Multiplayer_Host_Multiplayer():
	#var peer = ENetMultiplayerPeer.new()
	
	$menu.queue_free()
	$Music_Menu.queue_free()
	Music_Game()
	NextLevel()
	$Current_Level.Multiplayer_Host()
