extends Area3D

func _on_body_entered(_body):
	Globals.max_health += 1
	Globals.health += 1
	get_parent().get_parent().get_parent().end_map()
	queue_free()
