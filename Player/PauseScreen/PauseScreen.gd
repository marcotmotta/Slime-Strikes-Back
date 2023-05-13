extends Control

func _ready():
	hide()

func _input(_event):
	if Input.is_action_just_pressed("esc"):
		if get_tree().is_paused():
			resume_game()
		else:
			pause_game()

func pause_game():
	show()
	get_tree().paused = true

func resume_game():
	hide()
	get_tree().paused = false

func _on_main_menu_button_pressed():
	resume_game()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
