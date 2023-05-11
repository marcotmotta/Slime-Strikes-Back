extends Node3D

func _on_animation_player_animation_finished(anim_name):
	get_parent().animation_finished(anim_name)

func trigger_attack():
	get_parent().trigger_attack()
