extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var FramesToJump = 5
var timeInAirCount = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#@export var player_id:int = name.to_int():
@export var player_id:int:
	set(id):
		player_id = id
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$Camera.make_current()
	pass

func _physics_process(delta):
	# Add the gravity.
	#if is_multiplayer_authority():
	if not is_on_floor():
		velocity.y += gravity * delta
		timeInAirCount += 1
	else:
		timeInAirCount = 0
		
	if Input.is_action_just_pressed("reset"):
		position = Vector2i(0,0)
		get_node("CollisionShape2D").disabled = false
		
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or timeInAirCount < FramesToJump:
			velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
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

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
