extends CharacterBody3D

const abilities_singleton = preload("res://Abilities/Abilities.gd")
var abilities

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_buffed = false

func _ready():
	$Blob/AnimationPlayer.play("Idle-Animation")

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()
	$Blob.look_at(forward_direction)
	$CollisionShape3D.look_at(forward_direction)
	$ShootPosition.position = (get_forward_direction() - global_position).normalized() * 2

	#print(Engine.get_frames_per_second())

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 10

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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

	move_and_slide()

func get_forward_direction():
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var ray_origin = $Camera3D.project_ray_origin(mouse_pos_2d)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos_2d)

	var t = (position.y - ray_origin.y) / ray_dir.y
	return ray_origin + ray_dir * t

func heal(amount):
	Globals.health = min(Globals.health + amount, Globals.max_health)

func _input(event):
	# bubble
	if Input.is_action_just_pressed("1"):
		abilities.shoot_bubble(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)

	# arrow
	if Input.is_action_just_pressed("2"):
		abilities.shoot_arrow(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)

	# fireball
	if Input.is_action_just_pressed("3"):
		abilities.shoot_fireball(get_forward_direction(), get_global_position(), $ShootPosition.global_position, self)

	# heal
	if Input.is_action_just_pressed("4"):
		is_buffed = true
		heal(10)
		$BuffTimer.start(0.5)

func _on_buff_timer_timeout():
	is_buffed = false
