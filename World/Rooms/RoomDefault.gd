extends Node3D

@onready var player_scene = preload("res://Player/Player.tscn")

func _ready():
	randomize()

	# add map to room
	if Globals.current_room.scene:
		var map_scene = load("res://World/Rooms/" + Globals.current_room.scene + "/" + Globals.current_room.scene + ".tscn")
		var map_instance = map_scene.instantiate()
		add_child(map_instance)

	# spawn player here
	#var player_instance = player_scene.instantiate()
	#player_instance.position = $Map/Spawn.position
	#add_child(player_instance)
