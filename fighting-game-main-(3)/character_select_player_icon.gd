extends ColorRect

var chara_name = ""
var p_name = ""
var player_value = 0
var obj_color = Color.LIGHT_PINK
var text_color = Color.WHITE
var waitTimer =false
func _process(delta):
	$CharacterName.text = chara_name
	$PlayerLabel.text = p_name
	if Main.player[player_value-1] ==null:
		text_color = Color.WHITE
	
	else:
		text_color = Color.YELLOW
		$ColorRect.color = Color.WHITE
		waitTimer = true
		await(Main.wait(.05))
		waitTimer = false
	$CharacterName.set("theme_override_colors/default_color",text_color)
	if waitTimer == false:
		match player_value:
			1:
				obj_color = Color.LIGHT_PINK
			2:
				obj_color = Color.SKY_BLUE
			3:
				obj_color =  Color.GOLDENROD
			4:
				obj_color  = Color.PALE_GREEN
	$ColorRect.color = obj_color
