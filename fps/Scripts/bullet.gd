extends CharacterBody2D

var SPEED : int
var dir : Vector2

func send_data(speed : int, rot : float, initial_pos : Vector2, mouse : Vector2) -> void:
	SPEED = speed
	rotation_degrees = rot
	dir = initial_pos.direction_to(mouse)
	global_position = initial_pos

func _process(delta) -> void:
	velocity = (dir * SPEED * delta) * 30
	move_and_slide()
