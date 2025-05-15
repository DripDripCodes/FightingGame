extends Fighter

#Lokilani movement ability detaches legs, can 1. recall to legs or have legs recall to her 
#Note to self, add 1 second art. load time to start of match
var attack_queued = ""
var deltaG = 0
var duplicates = 0
#animation help
var animating = false
var actionable = 0

var hboxY = null
func _ready():
	super()
	tap_jump = false
	hboxY = $Area2D/CollisionShape.position
	creatorArea = 20
	for x in get_parent().get_children():
		if x.scene_file_path == self.scene_file_path:
			duplicates +=1
func _process(delta):
	edgeCheck()
	$RayCast2D.scale.x = facing
	$Area2D/CollisionShape.skew = -3*facing
	if actionable > 0:
		actionable -=1
	#bunk code
	$AnimatedSprite2D.scale.x = facing/1.6
		
	#end bunk code
	deltaG = delta
	if dodging:
		$AnimatedSprite2D.modulate = Color(10,10,10,10)
	else:
		$AnimatedSprite2D.modulate = Color(1,1,1)
		paletteSwap(duplicates)
	if not animating:
		sprite.play("default")
	#check if actionable
	if is_on_floor():
		if sprite.animation == "n_air" or  sprite.animation == "f_air" or  sprite.animation == "b_air" or \
		 sprite.animation == "u_air"  or  sprite.animation == "d_air":
			animating = false
			actionable = 10
			lagframes = 5
	if not grabbing and not grabbed and cooldown <=  0 and actionable <=0 and not dodging:
		#check if on floor
		#lag frames for animation = 1 frame of animation is 7 game frames long
 
		if is_on_floor():
			
			if Input.get_action_strength(left_button) < .2 and Input.get_action_strength(right_button) < .2\
			and not Input.is_action_pressed(down_button) and not Input.is_action_pressed(up_button) :
				if Input.is_action_just_pressed(light_attack):
					lAttack()
				if Input.is_action_just_pressed(med_attack):
					mAttack()
			if (Input.get_action_strength(left_button) > .2 or Input.get_action_strength(right_button) > .2) and\
			((facing*velocity.x) < 1.6 *speed) and not Input.is_action_pressed(up_button) and not Input.is_action_pressed(down_button):
				if Input.is_action_pressed(left_button):
					if Input.is_action_just_pressed(light_attack):
						ftilt()
						facing = -1
				if Input.is_action_pressed(right_button) and not Input.is_action_pressed(left_button) :
					if Input.is_action_just_pressed(light_attack):
						ftilt()
						facing = 1
			else:
				if (Input.get_action_strength(left_button) > .6 or Input.get_action_strength(right_button) > .6) and\
				((facing*velocity.x) >= 1.6*speed) and not Input.is_action_pressed(up_button) and not Input.is_action_pressed(down_button):
					if Input.is_action_pressed(left_button):
						if Input.is_action_just_pressed(light_attack):
							dash_attack()
							facing = -1
					if Input.is_action_pressed(right_button):
						if Input.is_action_just_pressed(light_attack):
							dash_attack()
							facing = 1
			if Input.is_action_pressed(up_button) and not Input.is_action_pressed(down_button):
				if Input.is_action_just_pressed(light_attack):
					utilt()
			if Input.is_action_pressed(down_button):
				if Input.is_action_just_pressed(light_attack):
					dtilt()
			if Input.is_action_just_pressed(grab):
				grabAttack()
				
		else:
			if Input.get_action_strength(left_button) < .3 and Input.get_action_strength(right_button) < .3 \
			and not Input.is_action_pressed(down_button) and not Input.is_action_pressed(up_button) :
				if Input.is_action_just_pressed(light_attack):
					n_air()
			if (Input.get_action_strength(left_button) > .3 or Input.get_action_strength(right_button) > .3) and\
				 not Input.get_action_strength(up_button) > .3 and not Input.get_action_strength(up_button) > .3:
				if facing == 1:
					if Input.is_action_pressed(right_button)  and not Input.is_action_pressed(left_button):
						if Input.is_action_just_pressed(light_attack):
							f_air()
					if Input.is_action_pressed(left_button):
						if Input.is_action_just_pressed(light_attack):
							b_air()
				if facing == -1:
					if Input.is_action_pressed(left_button)  and not Input.is_action_pressed(right_button):
						if Input.is_action_just_pressed(light_attack):
							f_air()
					if Input.is_action_pressed(right_button):
						if Input.is_action_just_pressed(light_attack):
							b_air()
			if Input.get_action_strength(up_button) > .3 and not Input.is_action_pressed(down_button):
				if Input.is_action_just_pressed(light_attack):
					u_air()
			if Input.get_action_strength(down_button) > .3:
				if Input.is_action_just_pressed(light_attack):
					d_air()	
	if grabbing and not grabbed and lagframes <=0 and not dodging:
		if Input.is_action_just_pressed(light_attack) or\
			Input.is_action_just_pressed(grab) or\
			Input.is_action_just_pressed(med_attack) :
			pummel()


##Attacks
func utilt():
	sprite.play("u_tilt")
	lagframes = 28
	actionable = 24
	await(wait(frames_to_seconds(2)))
	if not is_on_floor():
		u_air()
		return
	await(wait(frames_to_seconds(12)))
	createHitbox(6,-14,7,14,14,5,3,.2,50)
func dtilt():
	sprite.play("d_tilt")
	$Area2D/CollisionShape.scale.y = .7
	$Area2D/CollisionShape.position = hboxY
	$Area2D/CollisionShape.position.y +=3
	lagframes = 14
	actionable = 10
	await(wait(frames_to_seconds(2)))
	if not is_on_floor():
		d_air()
		return
	createHitbox(0,10,20,5,7,5,2,.3,20)
func ftilt():
	sprite.play("f_tilt")
	lagframes = 30
	actionable = 25
	await(wait(frames_to_seconds(2)))
	if not is_on_floor():
		f_air()
		return
	await(wait(frames_to_seconds(12)))
	createHitbox(1,-2,12,10,14,5,10,.9,50)
	createHitbox(11,-3,5,5,14,5,10,.9,50)

func lAttack():
	lagframes = 9 #1 start up, 5 active frames, 3 endlag frames
	await(wait(frames_to_seconds(2)))
	if Input.get_action_strength(right_button) > .2 or  Input.get_action_strength(left_button) > .2:
			ftilt()
			return
	if not is_on_floor():
		n_air()
		return
	await(wait(frames_to_seconds(3)))
	createHitbox(10,-10,20,20,5,10,10,.9,50)

func mAttack():
	sprite.play("mattack")
	lagframes = 35
func pummel(): 
	lagframes = 20
	createHitbox(0,-10,20,20,15,1,0,1,0)
func grabAttack():
	lagframes = 20 #5 start up, 10 active frames, 5 endlag frames
	await(wait(frames_to_seconds(5)))
	createGrabBox(10,-5,20,10,10,2*Engine.get_frames_per_second())
func dash_attack():
	sprite.play("dash_attack")
	move_attack = true
	lagframes = 38
	actionable = 38
	$Area2D/CollisionShape.position.x += 11*facing
	move_and_slide()
	await(wait(frames_to_seconds(1)))
	if not is_on_floor():
		$Area2D/CollisionShape.position = hboxY
		move_attack = false
		lagframes = 0
		dj+=1
		f_air()
		return
	await(wait(frames_to_seconds(1)))
	velocity.x = facing*speed*2
	await(wait(frames_to_seconds(3)))
	
	velocity.x = (facing*speed)*1.3
	await(wait(frames_to_seconds(2)))
	createHitbox(0,0,27,12,14,7,20,.9,10)
	await(wait(frames_to_seconds(3)))
	velocity.x = (facing*speed)*1.1
	move_and_slide()

	
func n_air():
	sprite.play("n_air")
	air_move = true 
	actionable = 18 
	await(wait(frames_to_seconds(2)))
	if facing == 1:
		if Input.get_action_strength(right_button) > .2:
			f_air()
			return
		if Input.get_action_strength(left_button) > .2:
			b_air()
			return
	else:
		if Input.get_action_strength(right_button) > .2:
			b_air()
			return
		if Input.get_action_strength(left_button) > .2:
			f_air()
			return
	createHitbox(-17,0,28,10,14,5,2,.3,10)

	

func f_air():
	sprite.play("f_air")
	actionable =  36
	air_move = true  
	
func b_air():
	sprite.play("b_air")
	actionable = 32
	lagframes = 32
	await(wait(frames_to_seconds(14)))
	velocity.x = (velocity.x*1.1) + (100*facing)

func u_air():
	sprite.play("u_air")
	air_move = true  
	actionable = 21

func d_air():
	sprite.play("d_air")
	actionable = 28
	lagframes = 42
	await(wait(frames_to_seconds(7)))
	velocity.y = jump_force/1.5

	
	

func _on_area_2d_area_entered(area):
	platformCalc(area)
	deathBoxCheck(area)
	if not dodging:
		grabBoxCheck(area)
		knockBackCalculations(area)







func frames_to_seconds(frames):

	return frames * deltaG


func _on_animated_sprite_2d_animation_looped():
	sprite.stop()
	animating = false
	$Area2D/CollisionShape.scale.y = 1
	$Area2D/CollisionShape.position = hboxY
	move_attack = false
	gravity = base_grav
	sprite.animation = "default"

func _on_animated_sprite_2d_animation_changed():
	if sprite.animation != "default":
		animating = true
	gravity = base_grav
	air_move = false
	print(gravity)  
func edgeCheck():
	if actionable >0 and !$RayCast2D.is_colliding() and is_on_floor():
		velocity.x = 0
		right=  0
		left=  0
		
