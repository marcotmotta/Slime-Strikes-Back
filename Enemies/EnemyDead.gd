extends Area3D

enum {
	BUBBLE,
	ARROW,
	FIREBALL,
	HEAL,
	SPIN
}

var pos
var rot

func _ready():
	global_position = pos
	global_rotation = rot

	$Model/AnimationPlayer.play("Die")

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
	queue_free()

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.select = true
		body.select_target = self

func _on_body_exited(body):
	if body.is_in_group('player'):
		if body.select_target == self:
			body.select = false
			body.select_target = null

func animation_finished(anim_name):
	if anim_name == 'Die':
		$CollisionShape3D.disabled = false
