extends Control

func _input(event):
	if Input.is_action_just_pressed("esc"):
		if get_tree().is_paused():
			resume_game()
		else:
			pause_game()

func pause_game():
	visible = true
	get_tree().paused = true

func resume_game():
	visible = false
	get_tree().paused = false

func _on_main_menu_button_pressed():
	resume_game()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
