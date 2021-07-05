class_name Enemy_Skeleton
extends Actor

var timer = 1.0
onready var main: KinematicBody2D = $"."
onready var patrol: Timer = $Patrol
onready var sprite: AnimatedSprite = $Graphics/Sprite
onready var visual: Node2D = $Graphics

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	pass

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		patroling()
		timer = 1.0

func patroling(flip = false):
	if flip:
		visual.scale.x = 1 if visual.scale.x < 0 else -1

func _physics_process(delta):
	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_Patrol_timeout():
	pass # Replace with function body.
