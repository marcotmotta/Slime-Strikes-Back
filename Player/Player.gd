extends CharacterBody3D

const SPEED = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()
	$MeshInstance3D.look_at(forward_direction, Vector3.UP)
	$CollisionShape3D.look_at(forward_direction, Vector3.UP)

	print(Engine.get_frames_per_second())

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 10

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func get_forward_direction():
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var ray_origin = $Camera3D.project_ray_origin(mouse_pos_2d)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos_2d)

	var t = (position.y - ray_origin.y) / ray_dir.y
	return ray_origin + ray_dir * t
