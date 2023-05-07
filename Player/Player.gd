extends CharacterBody3D

@onready var bubble_scene = preload("res://Player/Abilities/Bubble/Bubble.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()
	$MeshInstance3D.look_at(forward_direction)
	$CollisionShape3D.look_at(forward_direction)

	print(Engine.get_frames_per_second())

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

func _input(event):
	# attack
	if Input.is_action_just_pressed("action1"):
		var bubble_instance = bubble_scene.instantiate()
		get_parent().add_child(bubble_instance)
		bubble_instance.global_position = position
		bubble_instance.direction = (get_forward_direction() - get_global_position()).normalized()
		bubble_instance.damage = Globals.damage
