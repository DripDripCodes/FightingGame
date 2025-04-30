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
var creatorArea: int
#stun
var stunTime = 0
var selfStunTime = 0
func _ready():

	position.y += y_pos
	position.x += x_pos
	
func _physics_process(delta):
	
	if death_frames > 0:
		death_frames -= 1
	else:
		queue_free()


func _on_area_entered(area):
	if self.is_in_group("GrabBox") and area.get_parent().is_in_group("Fighter") and area.get_parent() != creator and\
		area.get_parent().is_on_floor():
		creator.grabbing = true
		area.get_parent().grabbed = true
		area.get_parent().position.x = creator.position.x+creatorArea*facing
		area.get_parent().grabee = area.get_parent().player_value
		creator.grabee = area.get_parent().player_value
		creator.grabber = creator.player_value
		area.get_parent().grabber = creator.player_value
		area.get_parent().facing = facing * -1
		Main.grab_timer[area.get_parent().player_value][creator.player_value] = damage + (.75*area.get_parent().current_damage)
		creator.cooldown =  damage + (.75*area.get_parent().current_damage) + 30
		area.get_parent().cooldown =  damage + (.75*area.get_parent().current_damage) + 25
		##frames work really weird idk what's happening
