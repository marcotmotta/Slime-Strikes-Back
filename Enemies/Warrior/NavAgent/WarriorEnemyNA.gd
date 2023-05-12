extends "res://Enemies/EnemyNA.gd"

func _ready():
	MAX_IDLE_TIME = 0.5
	max_health = 100
	health = 100
	move_speed = 10
	damage = 1
	range = 4

	is_follower = true

	abilities = abilities_singleton.new()
	add_child(abilities)

func attack():
	if target:
		look_at(target.position)

	$Model/AnimationPlayer.play('Attack')

func trigger_attack():
	abilities.spin_sword(target.position, "enemy", damage)

func animation_finished(anim_name):
	if anim_name == "Attack":
		set_state(IDLE)

func spin_animation_finished():
	pass
