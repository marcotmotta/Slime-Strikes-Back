extends CharacterBody3D

@export var target: Node3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const abilities_singleton = preload("res://Abilities/Abilities.gd")

enum {
	IDLE,
	RUNNING,
	ATTACKING
}

var MAX_IDLE_TIME = 1
var MAX_RANDOM_OFFSET_POS = 24

var state = IDLE
var abilities

var max_health
var health
var move_speed
var move_direction
var damage
var range
var is_follower
var turn_speed = 15

var remaining_idle_time = MAX_IDLE_TIME

func _process(delta):
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta * 10

		move_and_slide()
		return

	match state:
		IDLE:
			remaining_idle_time -= delta

			if remaining_idle_time <= 0:
				set_state(RUNNING)

		RUNNING:
			if is_follower:
				if is_move_over() or is_target_in_range():
					set_state(ATTACKING)
				else:
					move_to_target(delta)
			else:
				if is_move_over():
					set_state(ATTACKING)
				else:
					move_to_target(delta)

		ATTACKING:
			pass  # Awaiting the action ends.

func set_state(new_state):
	state = new_state

	match state:
		IDLE:
			remaining_idle_time = MAX_IDLE_TIME

		RUNNING:
			get_move_target()

		ATTACKING:
			attack()

func set_movement_target(movement_target):
	navigation_agent.set_target_position(movement_target)

func set_random_movement_target(radius):
	var random_offset = Vector3(randf_range(-radius, radius), 0, randf_range(-radius, radius))
	set_movement_target(global_position + random_offset)

func get_move_target():
	if target and is_follower:
		set_movement_target(target.position)
	else:
		while is_move_over() or not navigation_agent.is_target_reachable():
			set_random_movement_target(MAX_RANDOM_OFFSET_POS)

func move_to_target(delta):
	if target and is_follower: # The target position may have changed.
		get_move_target()

	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = (next_path_position - global_position).normalized() * move_speed

	if (next_path_position - global_position).length() > 0:
		var xform = transform.looking_at(next_path_position, Vector3.UP)
		transform = transform.interpolate_with(xform, turn_speed * delta)

	# Cloud be used to prevent the enemy beeing stuck on mesh corners.
	# velocity = velocity.move_toward(new_velocity, 0.95)

	velocity = new_velocity
	move_and_slide()

func is_move_over():
	return navigation_agent.is_navigation_finished()

func is_target_in_range():
	return target and (target.position - position).length() <= range

func attack():
	look_at(target.position)

func heal(amount):
	health = min(health + amount, max_health)

func take_damage(amount):
	health -= amount
