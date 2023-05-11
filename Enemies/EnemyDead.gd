extends Area3D

enum {
	BUBBLE,
	ARROW,
	FIREBALL,
	HEAL,
	SPIN
}

func select_action(body):
	match self.name:
		'MageDead':
			body.get_ability(FIREBALL)
		'WarriorDead':
			body.get_ability(SPIN)
		'ArcherDead':
			body.get_ability(ARROW)
		'ClericDead':
			body.get_ability(HEAL)

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.select = true
		body.select_target = self

func _on_body_exited(body):
	if body.is_in_group('player'):
		if body.select_target == self:
			body.select = false
			body.select_target = null
