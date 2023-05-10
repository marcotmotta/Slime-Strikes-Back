extends Node3D

func punch_animation_reach_track_point_1():
	get_parent().set_punch_area_monitoring_status(true)
	
func punch_animation_reach_track_point_2():
	get_parent().set_punch_area_monitoring_status(false)

func _on_animation_player_animation_finished(anim_name):
	get_parent().animation_finished(anim_name)
