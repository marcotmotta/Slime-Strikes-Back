extends Node3D

var ally
var damage
var collided_bodies

func _ready():
	collided_bodies = []

	$AnimationPlayer.play("Spin")

func _on_collision_area_body_entered(body):
	if not body.is_in_group(ally) and body not in collided_bodies:
		collided_bodies.append(body)
		body.take_damage(damage)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Spin":
		get_parent().spin_animation_finished()
		queue_free()
