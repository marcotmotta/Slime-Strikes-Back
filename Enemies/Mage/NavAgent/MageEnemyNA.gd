extends "res://Enemies/EnemyNA.gd"

func _ready():
	MAX_IDLE_TIME = 0
	max_health = 100
	health = 100
	move_speed = 10
	damage = 1
	range = 15

	is_follower = false

	abilities = abilities_singleton.new()
	add_child(abilities)

func attack():
	if target:
		look_at(target.position)

	$Model/AnimationPlayer.play('Attack')

func trigger_attack():
	abilities.shoot_fireball(target.position, position, position, 'enemy', damage)

func animation_finished(anim_name):
	if anim_name == "Attack":
		set_state(IDLE)
