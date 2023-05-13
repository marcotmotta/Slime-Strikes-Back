extends CharacterBody3D

@export var target: Node3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var heal_effect_scene = preload("res://Abilities/HealEffect.tscn")

@onready var mage_dead_scene = preload("res://Enemies/Mage/MageDead.tscn")
@onready var warrior_dead_scene = preload("res://Enemies/Warrior/WarriorDead.tscn")
@onready var archer_dead_scene = preload("res://Enemies/Archer/ArcherDead.tscn")
@onready var cleric_dead_scene = preload("res://Enemies/Cleric/ClericDead.tscn")

# sound
var attack_sound_scene = preload("res://Abilities/AttackSound.tscn")

var death_sound = preload("res://SFX/Enemy/Enemy death/Enemy-death-byfire.wav")

var hit_sound1 = preload("res://SFX/Enemy/Enemy hit/Enemy-hit-1.wav")
var hit_sound2 = preload("res://SFX/Enemy/Enemy hit/Enemy-hit-2.wav")
var hit_sound3 = preload("res://SFX/Enemy/Enemy hit/Enemy-hit-3.wav")
var hit_sound4 = preload("res://SFX/Enemy/Enemy hit/Enemy-hit-4.wav")
var hit_sound5 = preload("res://SFX/Enemy/Enemy hit/Enemy-hit-5.wav")

var hit_sounds = [hit_sound1, hit_sound2, hit_sound3, hit_sound4, hit_sound5]

var random_sound1 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-1.wav")
var random_sound2 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-2.wav")
var random_sound3 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-3.wav")
var random_sound4 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-4.wav")
var random_sound5 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-5.wav")
var random_sound6 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-6.wav")
var random_sound7 = preload("res://SFX/Enemy/Enemy grunt/Enemy-randomtalk-7.wav")

var random_sounds = [random_sound1, random_sound2, random_sound3, random_sound4, random_sound5, random_sound6, random_sound7]

const abilities_singleton = preload("res://Abilities/Abilities.gd")

enum {
	IDLE,
	RUNNING,
	ATTACKING,
	HURT
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

# health bar
var max_health_bar_size = 1

var is_boss = false

func _ready():
	randomize()
	set_state(IDLE)

func _process(_delta):
	$HealthBar.mesh.size.x = (float(health) * float(max_health_bar_size)) / float(max_health)

	if is_boss:
		$Control/BossHealth.visible = true
	$Control/BossHealth.max_value = max_health
	$Control/BossHealth.value = health

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
			if 'Cleric' not in self.name:
				look_at(target.position)

		HURT:
			pass

func set_state(new_state):
	state = new_state

	match state:
		IDLE:
			remaining_idle_time = MAX_IDLE_TIME
			$Model/AnimationPlayer.play('Idle')

		RUNNING:
			get_move_target()
			$Model/AnimationPlayer.play('Run')

		ATTACKING:
			# random sound
			var random_sound_instance = attack_sound_scene.instantiate()
			random_sound_instance.stream = Globals.choose(random_sounds)
			random_sound_instance.volume_db = -5
			random_sound_instance.pos = global_position
			get_parent().add_child(random_sound_instance)

			attack()

		HURT:
			$Model/AnimationPlayer.play('Damage')

func set_stun():
	set_state(HURT)

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
	next_path_position.y = global_position.y
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
	pass # should be overwritten by another script

func heal(amount):
	health = min(health + amount, max_health)

	var heal_effect = heal_effect_scene.instantiate()
	add_child(heal_effect)

func take_damage(amount):
	health -= amount

	# hit sound
	var hit_sound_instance = attack_sound_scene.instantiate()

	if health <= 0:
		hit_sound_instance.stream = death_sound
		hit_sound_instance.volume_db = -5
		hit_sound_instance.pos = global_position
		get_parent().add_child(hit_sound_instance)
		die()
	else:
		hit_sound_instance.stream = Globals.choose(hit_sounds)
		hit_sound_instance.volume_db = -5
		hit_sound_instance.pos = global_position
		get_parent().add_child(hit_sound_instance)

func die():
	var light = $OmniLight3D
	var enemy_dead

	if 'Mage' in self.name:
		enemy_dead = mage_dead_scene.instantiate()

	elif 'Warrior' in self.name:
		enemy_dead = warrior_dead_scene.instantiate()

	elif 'Archer' in self.name:
		enemy_dead = archer_dead_scene.instantiate()

	elif 'Cleric' in self.name:
		enemy_dead = cleric_dead_scene.instantiate()

	enemy_dead.pos = global_position
	enemy_dead.rot = global_rotation

	remove_child($OmniLight3D)
	enemy_dead.add_child(light)
	get_parent().add_child(enemy_dead)

	Globals.spawned_enemies.erase(self)
	queue_free()
