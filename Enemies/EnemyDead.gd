extends Area3D

enum {
	BUBBLE,
	ARROW,
	FIREBALL,
	HEAL
}

func _on_body_entered(body):
	if body.is_in_group('player'):
		match self.name:
				'MageDead':
					body.get_ability(FIREBALL)
					print('MageDead')
				'WarriorDead':
					body.get_ability(BUBBLE)
					print('WarriorDead')
				'ArcherDead':
					body.get_ability(ARROW)
					print('ArcherDead')
				'ClericDead':
					body.get_ability(HEAL)
					print('ClericDead')
