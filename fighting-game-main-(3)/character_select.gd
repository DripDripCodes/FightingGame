extends Node2D

var selector_parent = preload("res://selector.tscn") 
var selected_presets = [null,null,null,null]
var players_accounted = [0,0,0,0]
var store = 0
var z = 0
var selected_players = 0
var players_counted_for = 0
var player_count
func _ready():
	for x in range(0, Main.maxplayers-1):
		Main.player[x] = null
		Main.player_control[x]= null
	selected_presets = [null,null,null,null]
	players_accounted = [0,0,0,0]
	store = 0
	z = 0
	selected_players = 0
	players_counted_for = 0
func _process(delta):


	players_counted_for = Main.player.size() - Main.player.count(null)
	for x in ControllerPresets.keyboard_1p_controls:
		inputCheck(x,ControllerPresets.keyboard_1p_controls)
	for x in ControllerPresets.keyboard_2p_controls:
		inputCheck(x,ControllerPresets.keyboard_2p_controls)
	for x in ControllerPresets.controller_controls:
		inputCheck(x,ControllerPresets.controller_controls)
	if $HBoxContainer.get_children() != null:
		for x in range(0,$HBoxContainer.get_children().size()-1):
			if $HBoxContainer.get_children()[x].player_value > $HBoxContainer.get_children()[x+1].player_value:
				$HBoxContainer.move_child($HBoxContainer.get_children()[x], $HBoxContainer.get_children()[x].get_index() +1)
func inputCheck(x,preset):
	if !selected_presets.has(preset) and selected_players <= Main.maxplayers:
		if Input.is_action_just_pressed(x):
			var selector = selector_parent.instantiate()
			selector.controls = preset
			z=0
			for y in players_accounted:
				if y == 0:
					store = z
					players_accounted[z]= 1
					break
				z +=1
			selected_presets.append(preset)
			selector.player_value = store+1
			selected_players+=1
			selector.position = Vector2(50,50)
			add_child(selector)
			
	
