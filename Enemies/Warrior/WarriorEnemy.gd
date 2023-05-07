extends "res://Enemies/Enemy.gd"

func _ready():
	max_health = 100
	health = 100
	move_speed = 10
	damage = 10
	range = 5
	
	is_follower = true

func attack():
	if target:
		look_at(target.position)
	
	$AnimationPlayer.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		set_state(IDLE)
