extends Node2D

@onready var active_players = 2 
@onready var player_spawner = [null,null,null,null]

@onready var music_ap = $Music
@onready var se_ap = $SoundEffects


var sound_effect = false
var loop_time = 0
func _ready():


	active_players = Main.player.size() - Main.player.count(null)
	Main.controllers = Input.get_connected_joypads()
	var spawns = get_tree().get_nodes_in_group("Spawner")
	for x in range(0,Main.maxplayers-1):
		if Main.player[x] != null:
			player_spawner[x] = Main.player[x].instantiate()
			player_spawner[x].player_value = x+1
			player_spawner[x].position = spawns[x].position
		else:
			active_players+=1
	for x in range(0,Main.maxplayers-1):
		if Main.player[x] != null and player_spawner[x] != null:
			Main.playerdead[x+1] = false
			player_spawner[x].current_damage = 0
			player_spawner[x].current_stocks = Main.stocks
			add_child(player_spawner[x])
	#add_child(Main.player3)
	#add_child(Main.player4)
func _physics_process(delta):
	if get_tree().get_nodes_in_group("Fighter").size() <= 1:
		music_ap.volume_db -= .5
		if sound_effect == false:
			se_ap.stream = load("res://KO_SPvsTW.wav")
			
			se_ap.play()
			sound_effect = true
		var winner = get_tree().get_first_node_in_group("Fighter")
		Engine.time_scale = .05
		await(Main.wait(.2))
		if winner != null:
			Main.winner = winner.player_value
		else:
			Main.winner = 0 
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://win_screen.tscn")
		
