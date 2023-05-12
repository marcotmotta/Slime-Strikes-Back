extends "res://Enemies/EnemyNA.gd"

var enemy_target

func _ready():
	MAX_IDLE_TIME = 0
	max_health = 100
	health = 100
	move_speed = 10
	damage = 10
	range = 10

	is_follower = false

	abilities = abilities_singleton.new()
	add_child(abilities)

func attack():
	if Globals.spawned_enemies.size() > 0:
		enemy_target = Globals.spawned_enemies[randi() % Globals.spawned_enemies.size()]
		if enemy_target != self: look_at(enemy_target.position)

	$Model/AnimationPlayer.play('Attack')

func trigger_attack():
	if enemy_target and Globals.spawned_enemies.has(enemy_target):
		enemy_target.heal(damage)
	else:
		heal(damage)

	var heal_effect = heal_effect_scene.instantiate()
	heal_effect.sound = true
	add_child(heal_effect)

func animation_finished(anim_name):
	if anim_name == "Attack":
		set_state(IDLE)
