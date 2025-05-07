extends Node2D

@onready var active_players = 2
func _ready():
	Main.controllers = Input.get_connected_joypads()
	var spawns = get_tree().get_nodes_in_group("Spawner")
	for x in range(0,3):
		Main.player[x] = Main.fighter.instantiate()
		Main.player[x].player_value = x+1
		Main.player[x].position = spawns[x].position
	
	for x in range(0,active_players):
		Main.playerdead[x+1] = false
		Main.player[x].current_damage = 0
		Main.player[x].current_stocks = Main.stocks
		add_child(Main.player[x])
	#add_child(Main.player3)
	#add_child(Main.player4)
func _process(delta):
	if get_tree().get_nodes_in_group("Fighter").size() <= 1:
		var winner = get_tree().get_first_node_in_group("Fighter")
		Engine.time_scale = .05
		await(Main.wait(.1))
		if winner != null:
			Main.winner = winner.player_value
		else:
			Main.winner = 0 
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://win_screen.tscn")
		
