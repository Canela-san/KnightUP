extends Node

const lvlQuant = 2
var new_level_path = 0
var game_state = {"score": 0}
var level = 0
var coin = 0

func _ready():
	Menu()

func Menu():
	var menu = ResourceLoader.load("res://Scenes/menu.tscn")
	if menu:
		var Imenu = menu.instantiate()
		add_child(Imenu)
		Imenu.name = "menu"
		if Imenu.has_method("initialize"):
			Imenu.initialize(game_state)
		Imenu.connect("Start", Callable(self, "_on_control_start"))
		Imenu.connect("Options", Callable(self, "_on_control_options"))
		Imenu.connect("Quit", Callable(self, "_on_control_quit"))
	
func Music():
	var path = ResourceLoader.load("res://Scenes/music2.tscn")
	if path:
		var music = path.instantiate()
		add_child(music)
		music.name = "music"
		if music.has_method("initialize"):
			music.initialize(game_state)
		music.play()
func NextLevel():
	if level < lvlQuant:
		level += 1
	new_level_path = getPathLevel()
	# Remove o nível atual
	if has_node("Current_Level"):
		var current_level = $Current_Level
		current_level.queue_free()

	# Carrega o novo nível
	var new_level_resource = ResourceLoader.load(new_level_path)
	if new_level_resource:
		var new_level = new_level_resource.instantiate()
		add_child(new_level)
		new_level.name = "Current_Level"
		if new_level.has_method("initialize"):
			new_level.initialize(game_state)
		new_level.connect("AddPoint", Callable(self, "_on_lvl_1_add_point"))
		new_level.connect("Reset_Level", Callable(self, "reset_level"))
	else:
		pass

func _on_lvl_1_add_point():
	game_state["score"] += 1
	print(game_state["score"])
	if game_state["score"] == coin:
		NextLevel()
		
func reset_level():
	level -= 1
	NextLevel()

func getPathLevel():
	return "res://Scenes/lvl"+ str(level) +".tscn"

func _on_control_start():
	$menu.queue_free()
	Music()
	NextLevel()

func _on_control_options():
	pass
	
func _on_control_quit():
	get_tree().quit()
