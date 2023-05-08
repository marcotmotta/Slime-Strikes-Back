extends Node

@onready var bubble_scene = preload("res://Abilities/Bubble/Bubble.tscn")
@onready var arrow_scene = preload("res://Abilities/Arrow/Arrow.tscn")
@onready var fireball_scene = preload("res://Abilities/Fireball/Fireball.tscn")

func shoot_bubble(forward_direction, position, shoot_position, ally):
	var bubble_instance = bubble_scene.instantiate()
	get_parent().add_child(bubble_instance)
	bubble_instance.global_position = shoot_position
	bubble_instance.direction = (forward_direction - position).normalized()
	bubble_instance.damage = Globals.damage
	bubble_instance.ally = ally

func shoot_arrow(forward_direction, position, shoot_position, ally):
	for i in [-16, -8, 0, 8, 16]:
		var arrow_instance = arrow_scene.instantiate()
		get_parent().add_child(arrow_instance)
		arrow_instance.global_position = shoot_position
		arrow_instance.direction = (forward_direction - position).normalized().rotated(Vector3.UP, deg_to_rad(i))
		arrow_instance.damage = Globals.damage
		arrow_instance.ally = ally

func shoot_fireball(forward_direction, position, shoot_position, ally):
	var fireball_instance = fireball_scene.instantiate()
	get_parent().add_child(fireball_instance)
	fireball_instance.global_position = shoot_position
	fireball_instance.direction = (forward_direction - position).normalized()
	fireball_instance.damage = Globals.damage
	fireball_instance.ally = ally
