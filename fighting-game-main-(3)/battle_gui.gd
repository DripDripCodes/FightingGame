extends Control

var ui_elements := {}
var y=0
var lock = 0
var hBox = null
func _ready():
	for x in get_parent().get_children():
			if x is HBoxContainer:
				hBox = x

func _process(delta: float) -> void:
	pass

	if lock == 0:
		for x in get_tree().get_nodes_in_group("Fighter"):
			lock = 1
			print("Player 1")
			var label = Label.new()
			label.text = ("Player " + str(x.player_value))
			label.anchor_left = 0.5
			label.anchor_right = 0.5
			label.anchor_top = 0.5
			label.anchor_bottom = 0.5
			label.add_theme_font_size_override("font_size", 30)
			label.set_position(Vector2(100+y,600))
			hBox.add_child(label)
			ui_elements["Player"+ str(x.player_value)] = label
			y+=300
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
