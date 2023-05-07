# Ctrl Alt Jam

Ramones
Zillão
Krauser Ban
Jojo
Gado
Mark


var camera_distance = 8
var camera_height = 4

var camera_pivot
var camera
var speed = 100

func _ready():
	#camera_pivot = get_node("../CameraPivot")
	camera = $Camera3D

func _physics_process(delta):
	# Get the player's movement vector
	var velocity = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("move_back"):
		velocity.z += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	# Normalize the movement vector and scale it by the player's speed
	velocity = velocity.normalized() * speed

	# Rotate the player to face the mouse cursor
	look_at(get_viewport().get_global_mouse_position() - global_transform.origin, Vector3.UP)

	# Move the player using move_and_slide()
	move_and_slide()
	#if new_velocity.length_squared() > 0:
	#	velocity = new_velocity

	# Update the camera position
	#var target_position = global_transform.origin - global_transform.basis.z * camera_distance + Vector3.UP * camera_height
	#var camera_position = camera_pivot.global_transform.origin
	#camera_pivot.global_transform.origin = camera_position.linear_interpolate(target_position, camera_follow_speed * delta)
