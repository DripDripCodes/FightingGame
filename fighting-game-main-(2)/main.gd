extends Node

var players
var player1
var player2
var fighter = preload("res://fighter.tscn")
var grab_timer = []
var grid_width = 5
var grid_height = 5

@onready var playerdead = [true,false,false,false,false]
@onready var maxplayers = 4
func _ready():
	for i in grid_width:
		grab_timer.append([])
		for j in grid_height:
			grab_timer[i].append(0) # Set a starter value for each position
func _process(delta):
	for i in grid_width:
		for j in grid_height:
			if grab_timer[i][j] > 0:
				grab_timer[i][j] -= 1
