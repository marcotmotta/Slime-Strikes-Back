extends Node

const START_MAX_HEALTH = 100
const START_DAMAGE = 10
const START_SPEED = 20

# player variables
# (these will be reset after every run)
var max_health = START_MAX_HEALTH
var health
var damage = START_DAMAGE
var speed = START_SPEED

# world variables
var total_levels = 5
var current_level = 0

var maps = ['CombatMap1', 'CombatMap2']

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
