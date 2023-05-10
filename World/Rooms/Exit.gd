extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select_action(body):
	Globals.generate_room()
	Globals.reload_map()

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.select = true
		body.select_target = self

func _on_body_exited(body):
	if body.is_in_group('player'):
		if body.select_target == self:
			body.select = false
			body.select_target = null
