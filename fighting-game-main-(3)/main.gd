extends Node

var players
var player = [null,null,null,null]
var fighter = preload("res://fighter.tscn")
var grab_timer = []
var grid_width = 5
var grid_height = 5
var last_gt = []

#stocks and damage
var stocks = 1
#winner
var winner = 0
#controls set
@onready var controllers = [null,null,null,null]
@onready var controllers_set = [0,0,0,0,0]

@onready var playerdead = [true,false,false,false,false]
@onready var maxplayers = 4
func _ready():
	controllers = Input.get_connected_joypads()
	for i in grid_width:
		grab_timer.append([])
		last_gt.append([]) 
		for j in grid_height:
			grab_timer[i].append(0)
			last_gt[i].append(0)
func _process(delta):
	
	for i in grid_width:
		for j in grid_height:
			if grab_timer[i][j] > 0:
				grab_timer[i][j] -= 1
				last_gt[i][j] =1
				print("Last Gt:" + str(last_gt[i][j]))
func set_controls(player_value,Player):
	match player_value:
		1:
				Player.left_button = "a"
				Player.right_button = "d"
				Player.jump_button = "w"
				Player.down_button = "s"
				Player.light_attack = "j"
				Player.med_attack= "k"
				Player.grab = "h"
				Player.dodge = "l"
		
				
		2:
				Player.left_button = "ui_left"
				Player.right_button = "ui_right"
				Player.jump_button = "ui_up"
				Player.down_button = "ui_down"
				Player.light_attack = "z"
				Player.med_attack= "x"
				Player.grab = "v"
				Player.dodge = "c"
				#Player.left_button = "controller_left"
				#Player.right_button = "controller_right"
				#Player.jump_button = "jump_controller"
				#Player.down_button = "controller_down"
				#Player.up_button = "controller_up"
				#Player.light_attack = "lattack_controller"
				#Player.med_attack= "mattack_controller"
				#Player.grab = "grab_controller"
				#Player.med_attack = "mattack_controller"
				#Player.dodge = "controller_dodge"
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
