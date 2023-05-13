extends Area3D

var attack_sound_scene = preload("res://Abilities/AttackSound.tscn")
var sound = preload("res://SFX/Skills/Skill archer/Skill-archer.wav")

var direction = Vector3.FORWARD
var speed = 25
var damage = 5
var ally
var pos
var is_boss = false

func _ready():
	global_position = pos
	var attack_sound_instance = attack_sound_scene.instantiate()
	attack_sound_instance.stream = sound
	attack_sound_instance.volume_db = -10
	attack_sound_instance.pos = global_position
	get_parent().add_child(attack_sound_instance)

	if is_boss:
		$Expiration.wait_time *= 1.5
		$Expiration.start()

func _process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if not body.is_in_group(ally):
		if body.has_method('take_damage'):
			body.take_damage(damage)
		queue_free()

func _on_expiration_timeout():
	queue_free()
