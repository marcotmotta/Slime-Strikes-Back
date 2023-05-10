extends AudioStreamPlayer3D

var pos

func _ready():
	global_position = pos

func _on_timer_timeout():
	queue_free()
