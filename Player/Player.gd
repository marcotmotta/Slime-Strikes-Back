extends CharacterBody3D

@onready var bubble_scene = preload("res://Abilities/Bubble/Bubble.tscn")
@onready var arrow_scene = preload("res://Abilities/Arrow/Arrow.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$Blob/AnimationPlayer.play("Idle-Animation")

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()
	$Blob.look_at(forward_direction)
	$CollisionShape3D.look_at(forward_direction)
	$ShootPosition.position = (get_forward_direction() - global_position).normalized() * 2

	# print(Engine.get_frames_per_second())

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

	move_and_slide()

func get_forward_direction():
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var ray_origin = $Camera3D.project_ray_origin(mouse_pos_2d)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos_2d)

	var t = (position.y - ray_origin.y) / ray_dir.y
	return ray_origin + ray_dir * t

func shoot_bubble():
	var bubble_instance = bubble_scene.instantiate()
	get_parent().add_child(bubble_instance)
	bubble_instance.global_position = $ShootPosition.global_position
	bubble_instance.direction = (get_forward_direction() - get_global_position()).normalized()
	bubble_instance.damage = Globals.damage

func shoot_arrow():
	for i in [-20, -10, 0, 10, 20]:
		print(i)
		var arrow_instance = arrow_scene.instantiate()
		get_parent().add_child(arrow_instance)
		arrow_instance.global_position = $ShootPosition.global_position
		arrow_instance.direction = (get_forward_direction() - get_global_position()).normalized().rotated(Vector3.UP, deg_to_rad(i))
		arrow_instance.damage = Globals.damage

func _input(event):
	# bubble
	if Input.is_action_just_pressed("1"):
		shoot_bubble()

	# arrow
	if Input.is_action_just_pressed("2"):
		shoot_arrow()
