extends Node

@onready var bubble_scene = preload("res://Abilities/Bubble/Bubble.tscn")
@onready var arrow_scene = preload("res://Abilities/Arrow/Arrow.tscn")

func shoot_bubble(forward_direction, position, shoot_position):
	var bubble_instance = bubble_scene.instantiate()
	get_parent().add_child(bubble_instance)
	bubble_instance.global_position = shoot_position
	bubble_instance.direction = (forward_direction - position).normalized()
	bubble_instance.damage = Globals.damage

func shoot_arrow(forward_direction, position, shoot_position):
	for i in [-20, -10, 0, 10, 20]:
		var arrow_instance = arrow_scene.instantiate()
		get_parent().add_child(arrow_instance)
		arrow_instance.global_position = shoot_position
		arrow_instance.direction = (forward_direction - position).normalized().rotated(Vector3.UP, deg_to_rad(i))
		arrow_instance.damage = Globals.damage
