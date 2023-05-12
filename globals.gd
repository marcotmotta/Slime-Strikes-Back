extends Node

@onready var BattleAudio = preload('res://SFX/BGM/BMG-body.wav')

var BattleMusic = AudioStreamPlayer.new()

const START_MAX_HEALTH = 4
const START_SPEED = 8
const START_HEAL = 1

const START_DAMAGE = 20
const START_BUBBLE_DAMAGE = 5
const START_FIREBALL_DAMAGE = 35
const START_SPIN_DAMAGE = 20
const START_ARROW_DAMAGE = 5

# player variables
# (these will be reset after every run)
var max_health = START_MAX_HEALTH
var health
var speed = START_SPEED
var heal = START_HEAL

var damage = START_DAMAGE
var bubble_damage = START_BUBBLE_DAMAGE
var fireball_damage = START_FIREBALL_DAMAGE
var spin_damage = START_SPIN_DAMAGE
var arrow_damage = START_ARROW_DAMAGE

var ability_charges = 0

enum {
	BUBBLE,
	ARROW,
	FIREBALL,
	HEAL,
	SPIN
}

var current_ability = BUBBLE
var max_charges = 1

# world variables
var total_levels = 21
var current_level = 0

var maps = ['CombatMap1']

var spawned_enemies: Array = []

enum {
	ATK,
	HP,
	SPD
}

var reward_types = [ATK, HP, SPD]

var current_room = {}

func reset():
	randomize()
	current_room = {}

	generate_first_room()
	print(current_room)

	max_health = START_MAX_HEALTH
	health = max_health
	damage = START_DAMAGE
	speed = START_SPEED

	current_level = 0

	# music
	BattleMusic = AudioStreamPlayer.new()

	BattleMusic.stream = BattleAudio
	BattleMusic.volume_db = -20
	BattleMusic.set_name("BattleMusic")
	add_child(BattleMusic)

func generate_first_room():
	current_room = {
		'room_type': 'combat',
		'scene': 'CombatMap1',
		'enemies': 2,
		'reward_type': ATK,
		'last': false
	}

func generate_room():
	print('b')
	var enemies = 2 # (randi() % 2) + 1 + difficulty # (1 a 2) + difficulty (max 3) = max 5
	var new_room

	# last room
	print(current_level)
	#if current_level >= total_levels:
	#	new_room = {
	#		'room_type': 'combat',
	#		'scene': 'CombatMap1',
	#		'enemies': 1,
	#		'reward_type': ATK,
	#		'last': true
	#	}
	#else:
	new_room = {
		'room_type': 'combat',
		'scene': choose(maps),
		'enemies': enemies,
		'reward_type': choose(reward_types),
		'last': false
	}

	current_room = new_room
	print(current_room)

func reload_map():
	current_level += 1
	get_tree().reload_current_scene()

func _ready():
	randomize()
	reset()

# Utils

func choose(array):
	array.shuffle()
	return array.front()
