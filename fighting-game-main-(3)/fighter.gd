extends CharacterBody2D
class_name Fighter

#name

#movement variables
@export var speed: int
@export var gravity: int
@export var jump_force: int
@export var air_resist: float
@export var air_speed : int
@export var ramp_speed: float
@export var dodge_distance: int 
@export var player_value: int
@export var creatorArea: int

#directional inputs
var right = 0
var left = 0
var jump = 0 
var facing = 1 #1 right -1 left


#jumps
var tap_jump= true
var move_attack = false
var air_move = false
var base_grav = 0
var jump_button_timer = 0
#timers
var kbtimer = 0

#instances
var hitbox = preload("res://hitbox.tscn")
var grabbox = preload("res://grabbox.tscn")
#buttons
var left_button = ""
var right_button = ""
var jump_button = ""
var down_button = ""
var up_button = ""
var light_attack = ""
var med_attack= ""
var grab = ""
var dodge = ""

#inate values
var current_damage = 0
var current_stocks = 3 
var dj = 0
var fall_thru = 0
var fast_fall =0   


var air_dodge = true
var cooldown = 0
var lagframes = 0
var frameTimer = 0 
#grabs
var grabbing = false
var grabbed = false
var grabee = 0
var grabber = 0
var thrown = false

#dodging
var dodging = false
var attack = 0

@onready var sprite = $AnimatedSprite2D

func _ready():
	base_grav = gravity
	add_to_group("Fighter")
	set_controls()
func _physics_process(delta):
	attack -= 1
	fall_thru -= 1
	print(dj)
	#timers
	if fast_fall > 0:
		fast_fall -= 1 
	if cooldown > 0:
		cooldown -=3
	if lagframes > 0:
		lagframes -=1

	if frameTimer > 0 :
		frameTimer -= 1
		
	if dodging:
		move_and_slide()
	if not holdJumpFunc():
		jump_button_timer = 0
	if not dodging:
		if not grabbing and not grabbed:

			if is_on_floor():
				#dodging
				air_dodge = true
				dj = 2
				if cooldown <= 0  and lagframes <= 0:
					floor_dodge()
					if Input.is_action_pressed(down_button) and fall_thru <= 0:
						fall_thru = 20
					else:
						if Input.is_action_just_pressed(down_button) and fall_thru > 0:
							self.set_collision_mask_value(3,false)
							fall_thru = 0 
					
					if Input.is_action_pressed(left_button):
						if  left < 1:
							left += Input.get_action_strength(left_button)/ramp_speed
						if left > 1.1:
							left = 1 
						facing = -1
					else:
						if left > 0:
							left -=.3
						else:
							left  = 0
					if Input.is_action_pressed(right_button):
						if right < 1:
							right += Input.get_action_strength(right_button)/ramp_speed
						if right > 1.1:
							right = 1
						facing = 1
					else:
						if right > 0:
							right -=.3
						else:
							right  = 0
						
				if not dodging:
					if lagframes <= 0 and cooldown <=0:
						velocity.x = (right-left) * speed * delta *100
						
					else:
						if not move_attack:
							velocity.x = 0
			else:
				if Input.is_action_pressed(down_button)and fast_fall <=0: 
					velocity.y += 5
					fast_fall = 20
					
				if Input.is_action_just_pressed(down_button) and fast_fall > 0 and fast_fall < 18: 
					velocity.y += 100
					fast_fall = 0
					fall_thru = 0
				if cooldown <= 0 and lagframes <= 0 :
					inair_dodge()
					if Input.is_action_pressed(left_button) and velocity.x > -speed/2:
						left +=.1
						velocity.x-= .1 * air_speed/2
					if Input.is_action_pressed(right_button) and velocity.x < speed/2 : 
						velocity.x += .1 *air_speed/2
					
					if velocity.x > 0:
						velocity.x -= air_resist
					if velocity.x < 0:
						velocity.x += air_resist
					var face = 0
					
					if facing:
						face = -1
					else:
						face = 1
					##Air Jump

					if jumpFunc() and dj > 0 and air_move == false:
						print("air jump")
						velocity.y = jump_force
						if Input.is_action_pressed(left_button):
							left  = 1*Input.get_action_strength(left_button)
							facing = -1
						else:
							left = 0
						if Input.is_action_pressed(right_button): 
							right  = 1*Input.get_action_strength(right_button)
							facing = 1
						else:
							right = 0
						velocity.x = (right-left) * speed * delta *100
						dj-=1
				if (velocity.y < gravity * delta  * 5*20):
					velocity.y += gravity * delta  * 5

			move_and_slide()
			##Floor Jump
			if holdJumpFunc():
				jump_button_timer+=1
			if cooldown <= 0 and lagframes <= 0 :
					if is_on_floor() and jumpFunc():
						print("floor jump")
						velocity.y = jump_force/1.5
						if Input.is_action_pressed(left_button):
							left  = 1*Input.get_action_strength(left_button)
						else:
							left = 0
						if Input.is_action_pressed(right_button): 
							right  = 1*Input.get_action_strength(right_button)
						else:
							right = 0
						await(wait(3/Engine.get_frames_per_second()))
						if jump_button_timer > 3:
							velocity.y = jump_force/1.1
							dj-=1	
	if velocity.y < 0 and not dodging:
		self.set_collision_mask_value(3,false)
	if grabbed:

		if Input.is_action_just_pressed(left_button) or \
			Input.is_action_just_pressed(right_button) or\
			Input.is_action_just_pressed(jump_button) or\
			Input.is_action_just_pressed(up_button) or\
			Input.is_action_just_pressed(down_button): 
				Main.grab_timer[grabee][grabber] -= 10
				
	if Main.grab_timer[grabee][grabber] <=  0 and not thrown:
	
		if Main.last_gt[grabee][grabber] == 1 and grabee == player_value:
			velocity.y = .5 * 100 * -1 * 25* .1+(current_damage/100)
			velocity.x = .5 * 100 * (-1*facing) * 25* .1+(current_damage/100)
			move_and_slide()
			Main.last_gt[grabee][grabber] = 0
		grabbed = false
		grabbing = false
	checkDeath()
func createHitbox(x_pos,y_pos,x_size,y_size,deathframes,damage,knockback,knockback_x,stuntime):
	##Positions
	if facing == -1:
		x_pos = -1*(x_pos+creatorArea-(creatorArea-x_size))
	var newHBox = hitbox.instantiate()
	##Hitbox Values
	newHBox.scale = Vector2(x_size,y_size)
	newHBox.death_frames = deathframes
	newHBox.creator = self
	newHBox.y_pos = y_pos
	newHBox.x_pos = x_pos
	newHBox.kbx = knockback_x
	newHBox.knockback = knockback
	newHBox.kby = 1-knockback_x
	newHBox.facing = self.facing
	newHBox.damage = damage
	newHBox.stunTime = stuntime
	newHBox.creatorArea = creatorArea
	add_child(newHBox)

func createGrabBox(x_pos,y_pos,x_size,y_size,deathframes,timer):
	if facing == -1:
		x_pos = -1*(x_pos+creatorArea-(creatorArea-x_size))
	var newHBox = grabbox.instantiate()
	##Hitbox Values
	newHBox.scale = Vector2(x_size,y_size)
	newHBox.death_frames = deathframes
	newHBox.creator = self
	newHBox.y_pos = y_pos
	newHBox.x_pos = x_pos
	newHBox.facing = self.facing 
	newHBox.damage = timer
	newHBox.creatorArea = creatorArea
	add_child(newHBox)

func platformCalc(area):
	if not dodging:
		if area.name == "JumpThruPlatform" and velocity.y >= 0 and abs(position.x-area.global_position.x) < area.get_child(0).shape.size.x+30:
			self.set_collision_mask_value(3,true)

func knockBackCalculations(area):
	if area.is_in_group("Hitbox") and area.creator != self and attack < 0: 
			
			print_debug("I'm Hit " + str(player_value))
			area.queue_free()
			current_damage+= area.damage
			print(current_damage)
			velocity.y = area.kby * area.knockback * gravity * -1 * current_damage/100
			velocity.x = area.kbx * area.knockback * (area.facing) * 25* current_damage/100
			self.cooldown = area.stunTime

			move_and_slide()

func deathBoxCheck(area):
	if area.is_in_group("DeathBox"):
		current_stocks -= 1
		current_damage = 0 
		position = Vector2(0,-100)
		velocity = Vector2(0,0)
func checkDeath():
	if current_stocks <= 0: 
		Main.playerdead[player_value] = true
		queue_free()
func grabBoxCheck(area):
	if area.is_in_group("GrabBox") and area.creator != self:
		facing = -1 * area.facing
#from GBWD on the Godot forums
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func floor_dodge():
	if Input.is_action_just_pressed(dodge):
		if Input.is_action_pressed(down_button):
			velocity.y += dodge_distance*Input.get_action_strength(down_button)
		if Input.is_action_pressed(up_button):
			velocity.y += -dodge_distance*Input.get_action_strength(up_button)
		if Input.is_action_pressed(left_button):
			velocity.x += -dodge_distance*Input.get_action_strength(left_button)
		if Input.is_action_pressed(right_button):
			velocity.x += dodge_distance*Input.get_action_strength(right_button)
		dodging = true
		self.set_collision_mask_value(3,false)
		await(wait(.08))
		velocity = Vector2(0,0)
		lagframes = 10
		self.set_collision_mask_value(3,true)
		dodging = false
func inair_dodge():
	if not air_move:
		if Input.is_action_pressed(dodge) and air_dodge == true:
				velocity.y = 0
				if Input.is_action_pressed(down_button):
					velocity.y = dodge_distance*Input.get_action_strength(down_button)
				if Input.is_action_pressed(up_button):
					velocity.y = -dodge_distance*Input.get_action_strength(up_button)
				if Input.is_action_pressed(left_button):
					velocity.x = -dodge_distance*(Input.get_action_strength(left_button)+.2)
				if Input.is_action_pressed(right_button):
					velocity.x = dodge_distance*(Input.get_action_strength(right_button)+.2)
				dodging = true
				air_dodge = false
				gravity -= 50
				await(wait(.08))
				dodging = false
				gravity =base_grav 
				velocity = Vector2(0,0)

func jumpFunc():
	if tap_jump == false:
		return Input.is_action_just_pressed(jump_button)
	else:
		return Input.is_action_just_pressed(jump_button) or Input.is_action_just_pressed(up_button)
func holdJumpFunc():
	if tap_jump == false:
		return Input.is_action_pressed(jump_button)
	else:
		return Input.is_action_pressed(jump_button) or Input.is_action_pressed(up_button)
	
func jumpRelease():
	if tap_jump == false:
		return Input.is_action_just_released(jump_button)
	else:
		return Input.is_action_just_released(jump_button) or Input.is_action_just_released(up_button)
	


func set_controls():

	left_button = Main.player_control[player_value-1][2]
	right_button = Main.player_control[player_value-1][3]
	jump_button = Main.player_control[player_value-1][8]
	down_button = Main.player_control[player_value-1][1]
	up_button = Main.player_control[player_value-1][0]
	light_attack = Main.player_control[player_value-1][4]
	med_attack= Main.player_control[player_value-1][5]
	grab = Main.player_control[player_value-1][7]
	dodge = Main.player_control[player_value-1][6]


func paletteSwap(duplicates):
	if duplicates >= 2:
		match player_value:
			1:
				$AnimatedSprite2D.modulate = Color.WHITE
			2:
				$AnimatedSprite2D.modulate = Color.AQUA
			3:
				$AnimatedSprite2D.modulate = Color.LIGHT_PINK
	else:
		$AnimatedSprite2D.modulate = Color.WHITE
