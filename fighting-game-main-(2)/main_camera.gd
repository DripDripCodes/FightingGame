extends Camera2D

@onready var avg_y = 0
@onready var avg_x = 0
func _ready():
	zoom = Vector2(2,2)
func _physics_process(delta):
	var player_arr = get_tree().get_nodes_in_group("Fighter")
	avg_y = 0
	avg_x = 0
	for x in player_arr:
		avg_y += x.position.y
		avg_x += x.position.x
	avg_y /= player_arr.size()
	avg_x /= player_arr.size()
	if abs(avg_y-50 - position.y) > 25:
		position.y = avg_y-50
	position.x = avg_x
