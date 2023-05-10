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
			print('MageDead')
		'WarriorDead':
			body.get_ability(SPIN)
			print('WarriorDead')
		'ArcherDead':
			body.get_ability(ARROW)
			print('ArcherDead')
		'ClericDead':
			body.get_ability(HEAL)
			print('ClericDead')

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.select = true
		body.select_target = self

func _on_body_exited(body):
	if body.is_in_group('player'):
		if body.select_target == self:
			body.select = false
			body.select_target = null
