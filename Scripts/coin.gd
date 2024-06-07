extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var level_maneger = %level_maneger

func _on_body_entered(_body):
	level_maneger.add_point()
	animation_player.play("PickupAnimation")

