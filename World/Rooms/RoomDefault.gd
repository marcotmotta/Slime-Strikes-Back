extends Node3D

@onready var player_scene = preload("res://Player/Player.tscn")
@onready var warrior_enemy_scene = preload("res://Enemies/Warrior/WarriorEnemy.tscn")
@onready var mage_enemy_scene = preload("res://Enemies/Mage/MageEnemy.tscn")

func _ready():
	randomize()

	# add map to room
	if Globals.current_room.scene:
		var map_scene = load("res://World/Rooms/" + Globals.current_room.scene + "/" + Globals.current_room.scene + ".tscn")
		var map_instance = map_scene.instantiate()
		add_child(map_instance)

	# spawn player here
	var player_instance = player_scene.instantiate()
	player_instance.position = $Map.position + Vector3(0, 5, 0)
	add_child(player_instance)
	
	# spawn enemeies here
	var enemy_instance_1 = warrior_enemy_scene.instantiate()
	var enemy_instance_2 = mage_enemy_scene.instantiate()
	enemy_instance_1.position = $Map.position + Vector3(-20, 5, -20)
	enemy_instance_2.position = $Map.position + Vector3( 20, 5, -20)
	enemy_instance_1.target = player_instance
	enemy_instance_2.target = player_instance
	add_child(enemy_instance_1)
	add_child(enemy_instance_2)
	Globals.spawned_enemies.append(enemy_instance_1)
	Globals.spawned_enemies.append(enemy_instance_2)

# gambiarra a seguir (cuidado):

func _input(event):
	if Input.is_action_just_pressed("f1"):
		$ReloadScene.start(0.1)

func _on_reload_scene_timeout():
	print('reloading')
	Globals.generate_room()
	Globals.reload_map()
