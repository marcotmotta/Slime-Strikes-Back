extends "res://Enemies/EnemyNA.gd"

func _ready():
	max_health = 100
	health = 100
	move_speed = 10
	damage = 10
	range = 5

	is_follower = true

	abilities = abilities_singleton.new()
	add_child(abilities)

	$SpinCollisionArea/CollisionShape3D.shape.radius = range

func attack():
	if target:
		look_at(target.position)

	$SpinCollisionArea.monitoring = true
	$AnimationPlayer.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$SpinCollisionArea.monitoring = false
		set_state(IDLE)

func _on_spin_collision_area_body_entered(body):
	if body.is_in_group("player"):
		print("Player was hit by the spin attack!")
