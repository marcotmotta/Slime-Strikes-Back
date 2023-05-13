extends CharacterBody3D

const abilities_singleton = preload("res://Abilities/Abilities.gd")
var abilities

@onready var heal_effect_scene = preload("res://Abilities/HealEffect.tscn")
@onready var warrior_hat_scene = preload("res://Player/Items/WarriorHat.tscn")
@onready var mage_hat_scene = preload("res://Player/Items/MageHat.tscn")
@onready var cleric_hat_scene = preload("res://Player/Items/ClericHat.tscn")
@onready var archer_hat_scene = preload("res://Player/Items/ArcherHat.tscn")

# sound
var attack_sound_scene = preload("res://Abilities/AttackSound.tscn")
var eat_sound = preload("res://SFX/Blob/Blob absorb/Blob-absorb.wav")
var dash_sound = preload("res://SFX/Blob/Blob dash/Blob-dash.wav")
var punch_sound = preload("res://SFX/Blob/Blub punch/Blob-punch.wav")
var new_skill_mage_sound = preload("res://SFX/Blob/Blob new skill/new skill mage/Blob-newskill-mage.wav")
var new_skill_archer_sound = preload("res://SFX/Blob/Blob new skill/New skill archer/Blob-newskill-archer.wav")
var new_skill_warrior_sound = preload("res://SFX/Blob/Blob new skill/New skill knight/Blob-newskill-knight.wav")
var new_skill_cleric_sound = preload("res://SFX/Blob/Blob new skill/New skill bishop/Blob-newskill-bishop.wav")

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
var is_spining = false
var can_spin = true
var spining_damage = 10
var is_buffed = false
var heal_buff_duration = 2
var can_bubble = true
var bubble_cd = 2 # in seconds

# ui
var select = false
var select_target = null

var health_ui_start_x = 160
var health_ui_start_y = 70
var health_offset = 60

@onready var health_full = preload("res://UI/hud_coracao-cheio.png")
@onready var health_empty = preload("res://UI/hud_coracao-vazio.png")
@onready var dash_available_icon = preload("res://UI/hud_dash_1.png")
@onready var dash_unavailable_icon = preload("res://UI/hud_dash_2.png")
@onready var bubble_available_icon = preload("res://UI/hud_bolha_1.png")
@onready var bubble_unavailable_icon = preload("res://UI/hud_bolha_2.png")
@onready var warrior_hat_icon = preload("res://UI/hud_hat_warrior.png")
@onready var mage_hat_icon = preload("res://UI/hud_hat_mage.png")
@onready var cleric_hat_icon = preload("res://UI/hud_hat_cleric.png")
@onready var archer_hat_icon = preload("res://UI/hud_hat_archer.png")

var empty_hearts = 0
var full_hearts = 0

func _ready():
	$Blopinho/AnimationPlayer.play("Idle")

	# instance abilities singleton
	abilities = abilities_singleton.new()
	add_child(abilities)

	# update model
	update_hat()

	# ui
	generate_health_hearts()
	update_abilities_hud()

func _process(delta):
	# look direction
	var forward_direction = get_forward_direction()

	if not is_punching and not is_spining:
		$Blopinho.look_at(forward_direction)
		$CollisionShape3D.look_at(forward_direction)
		$ShootPosition.position = (forward_direction - global_position).normalized() * 2
		$PunchCollisionArea.position = (forward_direction - global_position).normalized() * 3.5

	# mouse pointer
	$MouseReference.global_position = forward_direction

	# select UI
	$CanvasLayer/Control/Select/Select.visible = select

	# health UI
	if ((full_hearts != Globals.health or empty_hearts + full_hearts != Globals.max_health) and Globals.health >= 0):
		generate_health_hearts()

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
		velocity *= heal_buff_duration
		$Healing.visible = true

	if is_dashing:
		velocity *= dash_power

	if not is_punching:
		move_and_slide()

	if not $Blopinho/AnimationPlayer.is_playing():
		$Blopinho/AnimationPlayer.play("Idle")

func generate_health_hearts():
	full_hearts = 0
	empty_hearts = 0

	for i in range(Globals.health):
		var heart = Sprite2D.new()
		heart.texture = health_full
		heart.position = Vector2(health_ui_start_x + health_offset * i, health_ui_start_y)
		heart.scale = Vector2(0.3, 0.3)
		$CanvasLayer/Control/HealthUI/Hearts.add_child(heart)
		full_hearts += 1

	for i in range(Globals.health, Globals.max_health):
		var heart = Sprite2D.new()
		heart.texture = health_empty
		heart.position = Vector2(health_ui_start_x + health_offset * i, health_ui_start_y)
		heart.scale = Vector2(0.3, 0.3)
		$CanvasLayer/Control/HealthUI/Hearts.add_child(heart)
		empty_hearts += 1

func update_abilities_hud():
	var ability_charges_test = $CanvasLayer/Control/AbilitiesUI/AbilityCharges
	var main_ability_sprite = $CanvasLayer/Control/AbilitiesUI/Main
	var dash_ability_sprite = $CanvasLayer/Control/AbilitiesUI/Dash
	
	if Globals.current_ability != BUBBLE:
		ability_charges_test.visible = true
		ability_charges_test.text = str(Globals.ability_charges)
	else:
		ability_charges_test.visible = false

	match Globals.current_ability:
		ARROW:
			main_ability_sprite.texture = archer_hat_icon
		FIREBALL:
			main_ability_sprite.texture = mage_hat_icon
		HEAL:
			main_ability_sprite.texture = cleric_hat_icon
		SPIN:
			main_ability_sprite.texture = warrior_hat_icon
		BUBBLE:
			main_ability_sprite.texture = bubble_available_icon if can_bubble else bubble_unavailable_icon

	if can_dash:
		dash_ability_sprite.texture = dash_available_icon
	else:
		dash_ability_sprite.texture = dash_unavailable_icon

func get_forward_direction():
	var mouse_pos_2d = get_viewport().get_mouse_position()

	var ray_origin = $Camera3D.project_ray_origin(mouse_pos_2d)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos_2d)
	var t = (position.y - ray_origin.y) / ray_dir.y

	return ray_origin + ray_dir * t

func heal(amount):
	Globals.health = min(Globals.health + amount, Globals.max_health)

	var heal_effect = heal_effect_scene.instantiate()
	heal_effect.sound = true
	add_child(heal_effect)

func get_ability(new_ability):
	var new_skill_sound_instance = attack_sound_scene.instantiate()

	Globals.current_ability = new_ability
	Globals.ability_charges = Globals.max_charges

	update_hat()
	update_abilities_hud()

	match new_ability:
		ARROW:
			new_skill_sound_instance.stream = new_skill_archer_sound
			new_skill_sound_instance.volume_db = -5
		FIREBALL:
			new_skill_sound_instance.stream = new_skill_mage_sound
		HEAL:
			new_skill_sound_instance.stream = new_skill_cleric_sound
			new_skill_sound_instance.volume_db = -5
		SPIN:
			new_skill_sound_instance.stream = new_skill_warrior_sound

	$Blopinho/AnimationPlayer.play('Eat')

	# new skill sound
	new_skill_sound_instance.pos = global_position
	get_parent().add_child(new_skill_sound_instance)

func update_hat():
	for hat in $Blopinho/HatPosition.get_children():
		hat.queue_free()

	match Globals.current_ability:
		ARROW:
			$Blopinho/HatPosition.add_child(archer_hat_scene.instantiate())
		FIREBALL:
			$Blopinho/HatPosition.add_child(mage_hat_scene.instantiate())
		HEAL:
			$Blopinho/HatPosition.add_child(cleric_hat_scene.instantiate())
		SPIN:
			$Blopinho/HatPosition.add_child(warrior_hat_scene.instantiate())

func _input(event):
	# dash
	if Input.is_action_just_pressed("space"):
		if can_dash and not is_punching:
			is_dashing = true
			can_dash = false
			$Blopinho/AnimationPlayer.play("Dash")
			$DashTimer.wait_time = dash_duration
			$DashTimer.start()

			# dash sound
			var dash_sound_instance = attack_sound_scene.instantiate()
			dash_sound_instance.stream = dash_sound
			dash_sound_instance.volume_db = -5
			dash_sound_instance.pos = global_position
			get_parent().add_child(dash_sound_instance)

	# punch ability
	if Input.is_action_just_pressed("action1"):
		if can_punch and not is_dashing:
			is_punching = true
			can_punch = false
			$Blopinho/AnimationPlayer.play("Punch")

			# punch sound
			var punch_sound_instance = attack_sound_scene.instantiate()
			punch_sound_instance.stream = punch_sound
			punch_sound_instance.volume_db = -5
			punch_sound_instance.pos = global_position
			get_parent().add_child(punch_sound_instance)

	# special ability
	if Input.is_action_just_pressed("action2"):
		if not is_dashing and not is_punching:
			if Globals.current_ability != BUBBLE or can_bubble:
				$Blopinho/AnimationPlayer.play("Shot")

	# bubble
	if Input.is_action_just_pressed("1"):
		Globals.current_ability = BUBBLE
		update_hat()
	# arrow
	if Input.is_action_just_pressed("2"):
		get_ability(ARROW)
	# fireball
	if Input.is_action_just_pressed("3"):
		get_ability(FIREBALL)
	# heal
	if Input.is_action_just_pressed("4"):
		get_ability(HEAL)
	# spin
	if Input.is_action_just_pressed("5"):
		get_ability(SPIN)

	# select
	if Input.is_action_just_pressed("q"):
		if select:
			select_target.select_action(self)
	
	# update UI
	update_abilities_hud()

func trigger_shot():
	if Globals.current_ability == BUBBLE and can_bubble:
		can_bubble = false
		abilities.shoot_bubble(get_forward_direction(), get_global_position(), $ShootPosition.global_position, 'player', Globals.bubble_damage)
		$BubbleCd.wait_time = bubble_cd
		$BubbleCd.start()
	elif Globals.ability_charges > 0:
		match Globals.current_ability:
			ARROW:
				abilities.shoot_arrow(get_forward_direction(), get_global_position(), $ShootPosition.global_position, 'player', Globals.arrow_damage)
			FIREBALL:
				abilities.shoot_fireball(get_forward_direction(), get_global_position(), $ShootPosition.global_position, 'player', Globals.fireball_damage)
			HEAL:
				is_buffed = true
				heal(Globals.heal)
				$BuffTimer.start(0.5)
			SPIN:
				if can_spin:
					can_spin = false
					is_spining = true
					abilities.spin_sword(get_forward_direction(), 'player', Globals.spin_damage)

		Globals.ability_charges -= 1
		if Globals.ability_charges == 0:
			Globals.current_ability = BUBBLE
			update_hat()

func set_punch_area_monitoring_status(status):
	$PunchCollisionArea.monitoring = status

func animation_finished(anim_name):
	match anim_name:
		'Eat':
			$Blopinho/AnimationPlayer.play("Idle")
		'Punch':
			$Blopinho/AnimationPlayer.play("Idle")
			is_punching = false
			can_punch = true

func spin_animation_finished():
	can_spin = true
	is_spining = false

func _on_buff_timer_timeout():
	is_buffed = false

func _on_dash_timer_timeout():
	is_dashing = false
	$Blopinho/AnimationPlayer.play("Idle")
	$DashCd.wait_time = dash_cd
	$DashCd.start()

func _on_dash_cd_timeout():
	can_dash = true
	update_abilities_hud()

func _on_bubble_cd_timeout():
	can_bubble = true
	update_abilities_hud()

func take_damage(amount):
	Globals.health -= amount

func _on_punch_collision_area_body_entered(body):
	if body.has_method('take_damage') and body.is_in_group('enemy'):
		body.take_damage(Globals.damage)
