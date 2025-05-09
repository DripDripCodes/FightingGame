extends Node

var players
var player = [null,null,null,null]
var player_control = [null,null,null,null]
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
@onready var controllers_set = [false,false,false,false]

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

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
