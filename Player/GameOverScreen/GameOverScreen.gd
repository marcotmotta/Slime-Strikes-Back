extends Control

func _ready():
	hide()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
