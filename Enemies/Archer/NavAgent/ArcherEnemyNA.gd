extends "res://Enemies/EnemyNA.gd"

func _ready():
	max_health = 100
	health = 100
	move_speed = 10
	damage = 10
	range = 15

	is_follower = true

	abilities = abilities_singleton.new()
	add_child(abilities)

func attack():
	if target:
		look_at(target.position)

	$AnimationPlayer.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		abilities.shoot_arrow(target.position, position, position, 'enemy')
		set_state(IDLE)
