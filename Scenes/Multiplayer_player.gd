extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var FramesToJump = 5
var timeInAirCount = 0
var direction:int = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#@export var player_id:int = name.to_int():

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera
@export var player_id:int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)
func _ready():
	camera.make_current()
	
func _enter_tree():
	#set_multiplayer_authority(name.to_int())
	pass

func _apply_animations(delta):
	if direction > 0:
			animated_sprite.flip_h = false
	elif direction < 0:
			animated_sprite.flip_h = true
		
	if is_on_floor():
		if !direction:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func _apply_movement_from_input(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
		timeInAirCount += 1
	else:
		timeInAirCount = 0
		
	if Input.is_action_just_pressed("reset"):
		position = Vector2i(0,0)
		get_node("CollisionShape2D").disabled = false
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or timeInAirCount < FramesToJump:
			velocity.y = JUMP_VELOCITY

	direction = %InputSynchronizer.input_direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
