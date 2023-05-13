extends "res://Enemies/EnemyNA.gd"

func _ready():
	MAX_IDLE_TIME = 0
	max_health = 100
	health = 100
	move_speed = 10
	damage = 1
	range = 15

	if is_boss:
		max_health *= 2.5
		health *= 2.5
		max_health_bar_size *= 2
		move_speed *= 1.5
		range *= 1.3
		$Model.scale *= 2
		$HealthBar.position.y *= 1.5

	is_follower = false

	abilities = abilities_singleton.new()
	add_child(abilities)

func attack():
	if target:
		look_at(target.position)

	$Model/AnimationPlayer.play('Attack')

func trigger_attack():
	if is_boss:
		abilities.shoot_fireball_boss(target.position, position, position, 'enemy', damage)
	else:
		abilities.shoot_fireball(target.position, position, position, 'enemy', damage)

func animation_finished(anim_name):
	if anim_name == "Attack":
		set_state(IDLE)
	elif anim_name == "Damage":
		set_state(IDLE)
