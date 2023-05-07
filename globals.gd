extends Node

const START_MAX_HEALTH = 100
const START_DAMAGE = 25
const START_SPEED = 30

# player variables
# (these will be reset after every run)
var max_health = START_MAX_HEALTH
var health
var damage = START_DAMAGE
var speed = START_SPEED

# world variables
var total_levels = 5
var current_level = 0

var maps = ['CombatMap1']

#enum {
#	ATK,
#	HP,
#	SPD
#}

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
		#'enemies': 2,
		# 'reward_type': ATK,
		'last': false
	}

# func generate_room:
#	pass
#	this needs to be called when generating a new room, before `reload_map()

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
