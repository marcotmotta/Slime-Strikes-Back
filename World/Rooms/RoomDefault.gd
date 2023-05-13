extends Node3D

@onready var player_scene = preload("res://Player/Player.tscn")

@onready var warrior_enemy_na_scene = preload("res://Enemies/Warrior/NavAgent/WarriorEnemyNA.tscn")
@onready var mage_enemy_na_scene = preload("res://Enemies/Mage/NavAgent/MageEnemyNA.tscn")
@onready var cleric_enemy_na_scene = preload("res://Enemies/Cleric/NavAgent/ClericEnemyNA.tscn")
@onready var archer_enemy_na_scene = preload("res://Enemies/Archer/NavAgent/ArcherEnemyNA.tscn")

var enemy_types
var enemy_types_boss

var spawn_options = ['1', '2', '3', '4', '5', '6']

@onready var exit_scene = preload("res://World/Rooms/Exit.tscn")

@onready var power_up_scene = preload("res://World/Rooms/PowerUp.tscn")

var player_instance

var map_ended = false

func _ready():
	randomize()
	Globals.spawned_enemies = []
	enemy_types = [warrior_enemy_na_scene, mage_enemy_na_scene, cleric_enemy_na_scene, archer_enemy_na_scene]
	enemy_types_boss = [mage_enemy_na_scene, archer_enemy_na_scene]

	# add map to room
	if Globals.current_room.scene:
		var map_scene = load("res://World/Rooms/" + Globals.current_room.scene + "/" + Globals.current_room.scene + ".tscn")
		var map_instance = map_scene.instantiate()
		add_child(map_instance)

	# play music
	if not Globals.get_node("/root/Globals/BattleMusic").playing:
		Globals.get_node("/root/Globals/BattleMusic").play()

	# spawn player here
	player_instance = player_scene.instantiate()
	player_instance.pos = $Map/PlayerPosition.global_position
	add_child(player_instance)

	# combat
	if  Globals.current_room.room_type == 'combat' and Globals.current_room.enemies > 0:
		spawn_options.shuffle()

		for enemy in range(Globals.current_room.enemies):
			var enemy_instance
			var pos = 'Marker3D' + spawn_options[enemy]
			if Globals.current_room.last:
				pos = 'Marker3D1'
				enemy_instance = Globals.choose(enemy_types_boss).instantiate()
				enemy_instance.is_boss = true
			else:
				enemy_instance = Globals.choose(enemy_types).instantiate()
			# Duplicating the health bar mesh to prevent enemies from sharing the same.
			enemy_instance.get_node("HealthBar").mesh = enemy_instance.get_node("HealthBar").mesh.duplicate()
			enemy_instance.target = player_instance
			add_child(enemy_instance)
			enemy_instance.global_position = $Map.get_node(pos).global_position
			Globals.spawned_enemies.append(enemy_instance)

	# free room
	elif Globals.current_room.room_type == 'free':
		var power_up_instance = power_up_scene.instantiate()
		$Map/PowerUpPosition.add_child(power_up_instance)

func _process(_delta):
	if not map_ended:
		if Globals.current_room.room_type == 'combat':
			if Globals.spawned_enemies.is_empty():
				end_map()

func end_map():
	map_ended = true
	# spawn exit
	var exit_instance = exit_scene.instantiate()
	$Map/ExitPosition.add_child(exit_instance)

# Gambiarra a seguir (cuidado)!
#func _input(_event):
#	if Input.is_action_just_pressed("f1"):
#		$ReloadScene.start(0.1)

func _on_reload_scene_timeout():
	pass
#	print('reloading')
#	Globals.generate_room()
#	Globals.reload_map()
