extends Area2D

#death timer
var death_frames = 0
#damage info
var damage = 0
var knockback = 0
var kbx = 0
var kby = 0
#position
var x_pos = 0
var y_pos = 0
#creator
var creator = null
var facing = 1
func _ready():

	position.y += y_pos
	position.x += x_pos
	
func _physics_process(delta):
	
	if death_frames > 0:
		death_frames -= 1
	else:
		queue_free()
