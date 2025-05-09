extends Node2D

var player = preload("res://fighter.tscn")

func _process(delta):
	for x in ControllerPresets.enter:
	
		if Input.is_action_just_pressed(x):
			get_tree().change_scene_to_file("res://character_select.tscn")
		
func _on_button_button_down():
	get_tree().change_scene_to_file("res://character_select.tscn")
