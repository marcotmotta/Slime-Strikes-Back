extends Node

func _ready():
	Globals.reset()

	$UI/CanvasLayer/ControlsScreen.hide()
	$UI/CanvasLayer/CreditsScreen.hide()

	Globals.get_node("/root/Globals/BattleMusic").stop()

func _input(_event):
	if Input.is_action_just_pressed("esc"):
		$UI/CanvasLayer/ControlsScreen.hide()
		$UI/CanvasLayer/CreditsScreen.hide()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://World/Rooms/RoomDefault.tscn")

func _on_controls_button_pressed():
	$UI/CanvasLayer/ControlsScreen.show()

func _on_credits_button_pressed():
	$UI/CanvasLayer/CreditsScreen.show()

func _on_quit_button_pressed():
	get_tree().quit()
