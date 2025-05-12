extends Camera2D

@onready var avg_y = 0
@onready var avg_x = 0
@onready var players: Array
var x_store = 0
var zoom_x ="standard"
func _ready():
	zoom = Vector2(3,3)
func _physics_process(delta):
	#zoom
	
	scale = Vector2(1 / zoom.x, 1 / zoom.y)
	var player_arr = get_tree().get_nodes_in_group("Fighter")
	avg_y = 0
	avg_x = 0
	for x in player_arr:
		players.append(x)
		avg_y += x.position.y
		avg_x += x.position.x
	for x in players:
		for y in players:
			if x!=y:
				zoom_set(x.position.distance_to(y.position))
	if player_arr.size() > 0:
		avg_y /= player_arr.size()
		avg_x /= player_arr.size()
	if abs(avg_y-50 - position.y) > 25:
		position.y = avg_y-50
	position.x = avg_x
	players.clear()

func zoom_set(distance):
	if distance > 200:
		zoom_x = "wide"
	if distance < 200:
		zoom_x = "standard"
