extends Node2D



func _ready():
	var spawns = get_tree().get_nodes_in_group("Spawner")
	Main.player1 = Main.fighter.instantiate()
	Main.player2 = Main.fighter.instantiate()
	Main.player3 = Main.fighter.instantiate()
	Main.player4 = Main.fighter.instantiate()
	Main.player1.player_value = 1
	Main.player2.player_value = 2
	Main.player3.player_value = 3
	Main.player4.player_value = 4

	Main.player1.position = spawns[0].position
	Main.player2.position = spawns[1].position
	#Main.player3.position = spawns[2].position
	#Main.player4.position = spawns[3].position
	add_child(Main.player1)
	add_child(Main.player2)
	#add_child(Main.player3)
	#add_child(Main.player4)
