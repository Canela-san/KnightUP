extends Area2D
@onready var game_maneger = %GameManeger
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	game_maneger.add_point()
	animation_player.play("PickupAnimation")
