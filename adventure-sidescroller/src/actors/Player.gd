class_name Player
extends Actor

const FLOOR_DETECT_DISTANCE = 20.0

onready var platform_detector: RayCast2D = $Platform_Detector
onready var sprite: AnimatedSprite = $Aiming/Sprite
onready var aiming: Node2D = $Aiming

func _ready():
	# Static types untuk menghindari warning
	var camera: Camera2D = $Camera

func _physics_process(delta):
	movement()
	
	var animation = animation_state()
	sprite.play(animation)


# CALCULATE MOVEMENT VELOCITY
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	# ____this function will calculates new velocity, also will allow to
	# interfere jump action____
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
		
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
		
	return velocity


# MOVEMENT
func movement():
	# ____calculated the direction based on the strength input____
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("move_jump") else 0
	)
	
	# ____jump can be interfered____
	var is_jump_interrupted = Input.is_action_just_released("move_jump") and _velocity.y < 0.0
	
	_velocity = calculate_move_velocity(
		_velocity,
		direction,
		speed,
		is_jump_interrupted
	)
	
	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	
	# ____aiming is positioned by the x position of the direction____
	if direction.x != 0:
		aiming.scale.x = 1  if direction.x > 0 else -1

# ANIMATION STATE
func animation_state():
	var state = "default"
	
	if is_on_floor():
		state = "run" if abs(_velocity.x) > .1 else "default"
	else:
		state = "fall" if _velocity.y > 0 else "jump"
	return state
