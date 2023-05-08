extends "res://Enemies/Enemy.gd"

func _ready():
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
		var enemy_target = Globals.spawned_enemies[randi() % Globals.spawned_enemies.size()]
		
		look_at(enemy_target.position)
		enemy_target.heal(damage) # WARNING: Using "damage" as the amount of healing.
	else:
		heal(damage) # WARNING: Using "damage" as the amount of healing.
	
	$AnimationPlayer.play("heal")
