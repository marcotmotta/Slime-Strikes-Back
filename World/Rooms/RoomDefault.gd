extends Node3D

@onready var player_scene = preload("res://Player/Player.tscn")

@onready var warrior_enemy_na_scene = preload("res://Enemies/Warrior/NavAgent/WarriorEnemyNA.tscn")
@onready var mage_enemy_na_scene = preload("res://Enemies/Mage/NavAgent/MageEnemyNA.tscn")
@onready var cleric_enemy_na_scene = preload("res://Enemies/Cleric/NavAgent/ClericEnemyNA.tscn")
@onready var archer_enemy_na_scene = preload("res://Enemies/Archer/NavAgent/ArcherEnemyNA.tscn")

var enemy_types

var spawn_options = ['1', '2', '3', '4', '5', '6']

@onready var exit_scene = preload("res://World/Rooms/Exit.tscn")

var player_instance

var map_ended = false

func _ready():
	randomize()
	Globals.spawned_enemies = []
	enemy_types = [warrior_enemy_na_scene, mage_enemy_na_scene, cleric_enemy_na_scene, archer_enemy_na_scene]

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
	player_instance.position = $Map.position + Vector3(0, 5, 0)
	add_child(player_instance)

	if Globals.current_room.enemies > 0:
		spawn_options.shuffle()

		for enemy in range(Globals.current_room.enemies):
			var enemy_instance = Globals.choose(enemy_types).instantiate()
			#if Globals.current_room.last:
			#	enemy_instance.is_boss = true
			var pos = 'Marker3D' + spawn_options[enemy]
			enemy_instance.target = player_instance
			add_child(enemy_instance)
			enemy_instance.global_position = $Map.get_node(pos).global_position
			Globals.spawned_enemies.append(enemy_instance)

	# spawn enemies here
	var enemy_instance_1 = warrior_enemy_na_scene.instantiate()
	enemy_instance_1.position = $Map.position + Vector3(-20, 5, -20)
	enemy_instance_1.target = player_instance
	#add_child(enemy_instance_1)
	#Globals.spawned_enemies.append(enemy_instance_1)

	var enemy_instance_2 = mage_enemy_na_scene.instantiate()
	enemy_instance_2.position = $Map.position + Vector3( 20, 5, -20)
	enemy_instance_2.target = player_instance
	#add_child(enemy_instance_2)
	#Globals.spawned_enemies.append(enemy_instance_2)

	var enemy_instance_3 = cleric_enemy_na_scene.instantiate()
	enemy_instance_3.position = $Map.position + Vector3( 15, 5, -20)
	enemy_instance_3.target = player_instance
	#add_child(enemy_instance_3)
	#Globals.spawned_enemies.append(enemy_instance_3)

	var enemy_instance_4 = archer_enemy_na_scene.instantiate()
	enemy_instance_4.position = $Map.position + Vector3(-15, 5, -20)
	enemy_instance_4.target = player_instance
	#add_child(enemy_instance_4)
	#Globals.spawned_enemies.append(enemy_instance_4)

func _process(delta):
	if not map_ended:
		if Globals.spawned_enemies.is_empty():
			end_map()

func end_map():
	map_ended = true
	# spawn exit
	var exit_instance = exit_scene.instantiate()
	$Map/ExitPosition.add_child(exit_instance)

# Gambiarra a seguir (cuidado)!
func _input(event):
	if Input.is_action_just_pressed("f1"):
		$ReloadScene.start(0.1)

func _on_reload_scene_timeout():
	print('reloading')
	Globals.generate_room()
	Globals.reload_map()
