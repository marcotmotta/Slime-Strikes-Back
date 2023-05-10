extends CharacterBody3D

const abilities_singleton = preload("res://Abilities/Abilities.gd")
var abilities

enum {
	BUBBLE,
	ARROW,
	FIREBALL,
	HEAL,
	SPIN
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction
var is_dashing = false
var can_dash = true
var dash_power = 5
var dash_duration = 0.15 # in seconds
var dash_cd = 0.3 # in seconds
var is_punching = false
var can_punch = true
var is_buffed = false

func _ready():
	$Blopinho/AnimationPlayer.play("Idle")

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()

	if not is_punching:
		$Blopinho.look_at(forward_direction)
		$CollisionShape3D.look_at(forward_direction)
		$ShootPosition.position = (forward_direction - global_position).normalized() * 2
		$PunchCollisionArea.position = (forward_direction - global_position).normalized() * 3.5
	
	$MouseReference.global_position = forward_direction

	# print(Engine.get_frames_per_second())

func _physics_process(delta):
	# add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta * 10

	# get the input direction and handle the movement/deceleration
	if not is_dashing and not is_punching:
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * Globals.speed
		velocity.z = direction.z * Globals.speed
	else:
		velocity.x = move_toward(velocity.x, 0, Globals.speed)
		velocity.z = move_toward(velocity.z, 0, Globals.speed)

	$Healing.visible = false
	if is_buffed:
		velocity *= 1.5
		$Healing.visible = true

	if is_dashing:
		velocity *= dash_power

	if not is_punching:
		move_and_slide()

func get_forward_direction():
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var ray_origin = $Camera3D.project_ray_origin(mouse_pos_2d)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos_2d)
	var t = (position.y - ray_origin.y) / ray_dir.y

	return ray_origin + ray_dir * t

func heal(amount):
	Globals.health = min(Globals.health + amount, Globals.max_health)

func get_ability(new_ability):
	Globals.current_ability = new_ability
	$Blopinho/AnimationPlayer.play('Eat')

func _input(event):
	# dash
	if Input.is_action_just_pressed("space"):
		if can_dash and not is_punching:
			is_dashing = true
			can_dash = false
			$Blopinho/AnimationPlayer.play("Dash")
			$DashTimer.wait_time = dash_duration
			$DashTimer.start()

	# punch ability
	if Input.is_action_just_pressed("action1"):
		if can_punch and not is_dashing:
			is_punching = true
			can_punch = false
			$Blopinho/AnimationPlayer.play("Punch")

	# special ability
	if Input.is_action_just_pressed("action2"):
		if not is_dashing and not is_punching:
			match Globals.current_ability:
				BUBBLE:
					abilities.shoot_bubble(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)
				ARROW:
					abilities.shoot_arrow(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)
				FIREBALL:
					abilities.shoot_fireball(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)
				HEAL:
					is_buffed = true
					heal(10)
					$BuffTimer.start(0.5)
				SPIN:
					set_spin_area_monitoring_status(true)
					await get_tree().create_timer(1).timeout
					set_spin_area_monitoring_status(false)

	# bubble
	if Input.is_action_just_pressed("1"):
		Globals.current_ability = BUBBLE
	# arrow
	if Input.is_action_just_pressed("2"):
		Globals.current_ability = ARROW
	# fireball
	if Input.is_action_just_pressed("3"):
		Globals.current_ability = FIREBALL
	# heal
	if Input.is_action_just_pressed("4"):
		Globals.current_ability = HEAL
	# spin
	if Input.is_action_just_pressed("5"):
		Globals.current_ability = SPIN

func set_punch_area_monitoring_status(status):
	$PunchCollisionArea.monitoring = status

func set_spin_area_monitoring_status(status):
	$SpinCollisionArea.monitoring = status

func animation_finished(anim_name):
	print("Animation finished: " + anim_name)

	match anim_name:
		'Eat':
			$Blopinho/AnimationPlayer.play("Idle")
		'Punch':
			$Blopinho/AnimationPlayer.play("Idle")
			is_punching = false
			can_punch = true

func _on_buff_timer_timeout():
	is_buffed = false

func _on_dash_timer_timeout():
	is_dashing = false
	$Blopinho/AnimationPlayer.play("Idle")
	$DashCd.wait_time = dash_cd
	$DashCd.start()

func _on_dash_cd_timeout():
	can_dash = true

func _on_punch_collision_area_body_entered(body):
	print(str(body) + " was punched!")

func _on_spin_collision_area_body_entered(body):
	print(str(body) + " was hitted by the spin!")
