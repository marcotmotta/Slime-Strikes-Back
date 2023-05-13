extends Area3D

func _ready():
	pass

func select_action(_body):
	Globals.generate_room()
	Globals.reload_map()

func _on_body_entered(body):
	if body.is_in_group('player'):
		select_action(body)
		#body.select = true
		#body.select_target = self

func _on_body_exited(body):
	if body.is_in_group('player'):
		if body.select_target == self:
			body.select = false
			body.select_target = null
