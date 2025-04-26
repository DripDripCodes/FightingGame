extends Node2D



func _ready():
	var spawns = [$Player_Spawn1,$Player_Spawn2]
	var player1 = Main.fighter.instantiate()
	var player2 = Main.fighter.instantiate()
	player1.player_value = 1
	player2.player_value = 2
	player1.position = spawns[0].position
	player2.position = spawns[1].position
	add_child(player1)
	add_child(player2)
