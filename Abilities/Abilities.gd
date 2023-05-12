extends Node

@onready var bubble_scene = preload("res://Abilities/Bubble/Bubble.tscn")
@onready var arrow_scene = preload("res://Abilities/Arrow/Arrow.tscn")
@onready var fireball_scene = preload("res://Abilities/Fireball/Fireball.tscn")
@onready var spin_scene = preload("res://Abilities/Spin/Spin.tscn")

func shoot_bubble(forward_direction, position, shoot_position, ally, damage):
	var bubble_instance = bubble_scene.instantiate()
	bubble_instance.pos = shoot_position
	get_parent().get_parent().add_child(bubble_instance)
	bubble_instance.direction = (forward_direction - position).normalized()
	bubble_instance.damage = damage
	bubble_instance.ally = ally

func shoot_arrow(forward_direction, position, shoot_position, ally, damage):
	for i in [-16, -8, 0, 8, 16]:
		var arrow_instance = arrow_scene.instantiate()
		arrow_instance.pos = shoot_position
		get_parent().get_parent().add_child(arrow_instance)
		arrow_instance.direction = (forward_direction - position).normalized().rotated(Vector3.UP, deg_to_rad(i))
		arrow_instance.damage = damage
		arrow_instance.ally = ally

func shoot_fireball(forward_direction, position, shoot_position, ally, damage):
	var fireball_instance = fireball_scene.instantiate()
	fireball_instance.pos = shoot_position
	get_parent().get_parent().add_child(fireball_instance)
	fireball_instance.direction = (forward_direction - position).normalized()
	fireball_instance.damage = damage
	fireball_instance.ally = ally

func spin_sword(forward_direction, ally, damage):
	var spin_instance = spin_scene.instantiate()
	get_parent().add_child(spin_instance)
	spin_instance.look_at(forward_direction)
	spin_instance.damage = damage
	spin_instance.ally = ally
