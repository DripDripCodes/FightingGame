extends Control

var ui_elements := {}
var y=0
var lock = 0
func _ready():
	pass

func _process(delta: float) -> void:
	for child in get_parent().get_children():
		if child is Camera2D:
			var time = 0
			time += delta *10
			time = clampf(time, 0.0, 1.0)
			global_position = lerp(global_position, child.global_position, time)

	if lock == 0:
		for x in get_tree().get_nodes_in_group("Fighter"):
			lock = 1
			print("Player 1")
			var label = Label.new()
			label.text = ("Player " + str(x.player_value))
			label.set_position(Vector2(-150+y,100))
			add_child(label)
			ui_elements["Player"+ str(x.player_value)] = label
			y+=250
	for x in get_tree().get_nodes_in_group("Fighter"):
		match x.player_value:
			1:
				ui_elements["Player1"].text =("Player " + str(x.player_value) + ": " + str(x.current_damage) + "\nStocks: "+ str(x.current_stocks))
			2:
				ui_elements["Player2"].text =("Player " + str(x.player_value) + ": " + str(x.current_damage) + "\nStocks: "+ str(x.current_stocks))
			3:
				ui_elements["Player3"].text =("Player " + str(x.player_value) + ": " + str(x.current_damage) + "\nStocks: "+ str(x.current_stocks))
			4:
				ui_elements["Player4"].text =("Player " + str(x.player_value) + ": " + str(x.current_damage) + "\nStocks: "+ str(x.current_stocks))
	for i in range(1,4):
		if Main.playerdead[i] == true:
			ui_elements["Player"+str(i)].text =("Player " + str(i) + ": 0\nStocks: 0")
