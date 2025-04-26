extends CharacterBody2D
class_name Fighter


#movement variables
@export var speed: int
@export var gravity: int
@export var jump_force: int
@export var air_resist: float
@export var player_value: int

#directional inputs
var right = 0
var left = 0
var jump = 0 
var facing = 1 #1 right -1 left


#timers
var kbtimer = 0
var hitbox = preload("res://hitbox.tscn")
var left_button = ""
var right_button = ""
var jump_button = ""
var light_attack = ""
func _ready():
	add_to_group("Fighter")
	match player_value:
		1:
			left_button = "a"
			right_button = "d"
			jump_button = "w"
			light_attack = "j"
		2:
			left_button = "ui_left"
			right_button = "ui_right"
			jump_button = "ui_up"

func _physics_process(delta):
	if is_on_floor():
		if Input.is_action_pressed(left_button):
			left  = 1
			facing = -1
		else:
			left = 0
		if Input.is_action_pressed(right_button): 
			right  = 1
			facing = 1
		else:
			right = 0
		velocity.x = (right-left) * speed
	else:

		if Input.is_action_pressed(left_button) and velocity.x > -speed/2:
			left +=.1
			velocity.x-= .1 * speed/2
		if Input.is_action_pressed(right_button) and velocity.x < speed/2 : 
			velocity.x += .1 *speed/2
		if velocity.x > 0:
			velocity.x -= air_resist
		if velocity.x < 0:
			velocity.x += air_resist

	move_and_slide()
	if not is_on_floor():
		var face = 0
		velocity.y += gravity * delta  * 5
		if facing:
			face = -1
		else:
			face = 1
	if Input.is_action_just_pressed(jump_button) and is_on_floor():
		velocity.y = jump_force

func createHitbox(x_pos,y_pos,x_size,y_size,deathframes,damage,knockback,knockback_x):
	##Positions
	if facing == -1:
		x_pos = -1*x_pos-20
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
	add_child(newHBox)

func platformCalc(area):
	print("jumpthru")
	if area.name == "JumpThruPlatform" and velocity.y < 40:
		self.set_collision_mask_value(3,false)
	if area.name == "JumpThruPlatform" and velocity.y >= 40:
		self.set_collision_mask_value(3,true)

func knockBackCalculations(area):
	if area.is_in_group("Hitbox") and area.creator != self: 
			print_debug("I'm Hit " + str(player_value))
			area.queue_free()
			velocity.y = area.kby * area.knockback * gravity * -1
			velocity.x = area.kbx * area.knockback * (area.facing) * 25
			move_and_slide()

#from GBWD on the Godot forums
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
