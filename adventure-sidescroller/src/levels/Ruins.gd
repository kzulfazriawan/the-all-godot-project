extends Node2D

const LIMIT_LEFT = -660
const LIMIT_TOP = -1000
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 1780

func _ready():
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_bottom = LIMIT_BOTTOM
