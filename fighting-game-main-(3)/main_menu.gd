extends Node2D

var player = preload("res://fighter.tscn")
func _on_button_button_down():
	get_tree().change_scene_to_file("res://stage.tscn")
	
