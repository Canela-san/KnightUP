extends Node2D

var speed = 60 * randf_range(0.8, 2)
var direction = randi_range(0, 2) * 2 - 1
var paused = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight
@onready var level_maneger = %level_maneger

func _process(delta):
	if paused:
		return
	if ray_cast_left.is_colliding() or !ray_cast_down_left.is_colliding(): 
		direction = 1
		animated_sprite.flip_h = false
	if ray_cast_right.is_colliding() or !ray_cast_down_right.is_colliding(): 
		direction = -1
		animated_sprite.flip_h = true
	
	position.x += direction * speed * delta

func death():
	level_maneger.death()

