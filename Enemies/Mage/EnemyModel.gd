extends Node3D

func _on_animation_player_animation_finished(anim_name):
	get_parent().animation_finished(anim_name)

func shoot_fireball():
	get_parent().shoot_fireball()
