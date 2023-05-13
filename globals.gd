extends Node

@onready var BattleAudio = preload('res://SFX/BGM/BMG-body.wav')

var BattleMusic = AudioStreamPlayer.new()

const START_MAX_HEALTH = 4
const START_SPEED = 9
const START_HEAL = 1

const START_DAMAGE = 25
const START_BUBBLE_DAMAGE = 10
const START_FIREBALL_DAMAGE = 40
const START_SPIN_DAMAGE = 35
const START_ARROW_DAMAGE = 15

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
var total_levels = 9 # 3 combat -> 1 free -> 3 combat -> 1 free -> 1 boss
var current_level = 1
var free_room_frequency = 4

var maps = ['CombatMap1']

var spawned_enemies: Array = []

var current_room = {}

func reset():
	randomize()
	current_room = {}

	generate_first_room()
	print(current_room)

	max_health = START_MAX_HEALTH
	health = max_health
	speed = START_SPEED
	heal = START_HEAL

	bubble_damage = START_BUBBLE_DAMAGE
	fireball_damage = START_FIREBALL_DAMAGE
	spin_damage = START_SPIN_DAMAGE
	arrow_damage = START_ARROW_DAMAGE

	current_ability = BUBBLE
	max_charges = 1

	current_level = 1

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
		'last': false
	}

func generate_room():
	var difficulty
	if current_level < 4:
		difficulty = 1
	else:
		difficulty = 2

	var enemies = (randi() % 2) + 2 + difficulty # (2 a 3) + difficulty (max 4) = max 5
	var new_room

	# last room
	print(difficulty)
	if ((current_level + 1) >= total_levels):
		new_room = {
			'room_type': 'combat',
			'scene': 'CombatMap1',
			'enemies': 1,
			'last': true
		}
	else:
		if ((current_level + 1) % free_room_frequency == 0):
			new_room = {
				'room_type': 'free',
				'scene': choose(maps),
				'last': false
			}
		else:
			new_room = {
				'room_type': 'combat',
				'scene': choose(maps),
				'enemies': enemies,
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
