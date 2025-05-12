extends Node2D


var controls = ControllerPresets.keyboard_1p_controls
var player_value = 0
var on_node = false
var current_character_selected
var current_hover
var current_hover_name = ""
@onready var player_icon_prefab = preload("res://character_select_player_icon.tscn")
@onready var hbox 
var player_icon = null

var counter = 0 
func _ready():
	for x in get_parent().get_children():
		if x is HBoxContainer:
			hbox = x
	player_icon = player_icon_prefab.instantiate()
	player_icon.player_value = player_value
	player_icon.chara_name = ""
	player_icon.p_name = "P" + str(player_value)
	hbox.add_child(player_icon)
func _process(delta):
	#back out calc
	if counter >= 50:
		Main.player[player_value-1] = null
		Main.player_control[player_value-1]= null
		var preset_backout = get_parent().selected_presets.find(controls)

		get_parent().selected_presets[preset_backout] = null
		get_parent().players_accounted[player_value-1] = 0
		get_parent().selected_players-= 1
		player_icon.queue_free()
		queue_free()
		
		
	if player_icon != null:
		player_icon.chara_name = current_hover_name
		
		
	if Input.is_action_pressed(controls[0]):
		position.y -= Input.get_action_strength(controls[0])*3
	if Input.is_action_pressed(controls[1]):
		position.y += Input.get_action_strength(controls[1])*3
	if Input.is_action_pressed(controls[2]):
		position.x -= Input.get_action_strength(controls[2])*3
	if Input.is_action_pressed(controls[3]):
		position.x += Input.get_action_strength(controls[3])*3
	for x in ControllerPresets.enter:
	
		if Input.is_action_just_pressed(x) and Main.player[player_value-1] != null and \
		get_parent().players_counted_for >= get_parent().selected_players and get_parent().players_counted_for >1:

			get_tree().change_scene_to_file("res://stage.tscn")
		
	#confirm selection
	if Input.is_action_just_pressed(controls[4]) and on_node == true :
		Main.player[player_value-1] = current_hover
		Main.player_control[player_value-1]= controls
		player_icon.color = Color.WHITE
		
	#cancel selection
	if Input.is_action_just_pressed(controls[5]):
		Main.player[player_value-1] = null
		Main.player_control[player_value-1]= null
		if on_node == false:
			current_hover_name = ""
		else:
			$Sprite2D/Area2D.set_collision_mask_value(1,false)
			await(Main.wait(.05))
			$Sprite2D/Area2D.set_collision_mask_value(1,true)
			
	#back out
	if Input.is_action_pressed(controls[5]):
		counter +=1
	else:
		counter = 0 
func _on_area_2d_area_entered(area):
	if area.is_in_group("CharacterNode"):
		$Sprite2D/Area2D/CollisionShape2D.debug_color = Color.BLUE
		on_node = true
		current_hover = area.get_parent().get_parent().character
		if Main.player[player_value-1] == null:
			current_hover_name = area.get_parent().get_parent().text
func _on_area_2d_area_exited(area):
	if area.is_in_group("CharacterNode"):
		$Sprite2D/Area2D/CollisionShape2D.debug_color = Color.WHITE
		on_node = false
		current_hover = null
		if Main.player[player_value-1] == null:
			current_hover_name = ""
