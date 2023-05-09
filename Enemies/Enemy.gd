extends CharacterBody3D

@export var target: Node3D

const abilities_singleton = preload("res://Abilities/Abilities.gd")
var abilities

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum {
	IDLE,
	RUNNING,
	ATTACKING
}

var MAX_IDLE_TIME = 1
var MAX_WALKING_TIME = 2

var state = IDLE

var max_health
var health
var move_speed
var move_direction
var damage
var range
var is_follower

var remaining_idle_time = MAX_IDLE_TIME
var remaining_walking_time = MAX_WALKING_TIME

func _process(delta):
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta * 10
		move_and_slide()

	match state:
		IDLE:
			remaining_idle_time -= delta

			if remaining_idle_time <= 0:
				set_state(RUNNING)

		RUNNING:
			if is_follower:
				if is_target_in_range():
					set_state(ATTACKING)
				else:
					move_to_direction()
			else:
				remaining_walking_time -= delta
				
				if remaining_walking_time <= 0:
					set_state(ATTACKING)
				else:
					move_to_direction()

		ATTACKING:
			pass  # Awaiting the action ends.

func set_state(new_state):
	state = new_state

	match state:
		IDLE:
			remaining_idle_time = MAX_IDLE_TIME

		RUNNING:
			remaining_walking_time = MAX_WALKING_TIME
			gen_move_direction()

		ATTACKING:
			attack()

func gen_move_direction():
	if target:
		if is_follower:
			move_direction = (target.position - position).normalized()
		else:
			move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()

func move_to_direction():
	if target:
		if is_follower: # The target direction may have changed.
			gen_move_direction()

		if move_direction:
			velocity.x = move_direction.x * move_speed
			velocity.z = move_direction.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)

		look_at(position + move_direction) # Look forward.

		move_and_slide()

func is_target_in_range():
	if target:
		if (target.position - position).length() <= range:
			return true

	return false

func attack():
	look_at(target.position)

func heal(amount):
	health = min(health + amount, max_health)

func take_damage(amount):
	health -= amount
