extends Fighter

#Lokilani movement ability detaches legs, can 1. recall to legs or have legs recall to her 
#Note to self, add 1 second art. load time to start of match
var attack_queued = ""
var deltaG = 0

func _ready():
	super()
	creatorArea = 20
func _process(delta):
	#bunk code
	$AnimatedSprite2D.scale.x = facing/1.6
		
	#end bunk code
	deltaG = delta
	if dodging:
		$AnimatedSprite2D.modulate = Color(10,10,10,10)
	else:
		match player_value:
			1:
				$AnimatedSprite2D.modulate = Color.WHITE
			2:
				$AnimatedSprite2D.modulate = Color.AQUA
	#check if actionable
	if not grabbing and not grabbed and cooldown <=  0 and lagframes <=0 and not dodging:
		#check if on floor
		if is_on_floor():
			if not Input.is_action_pressed(right_button) and not Input.is_action_pressed(left_button):
				if Input.is_action_just_pressed(light_attack):
					lAttack()
				if Input.is_action_just_pressed(med_attack):
					mAttack()
			if Input.is_action_just_pressed(grab):
				grabAttack()
	if grabbing and not grabbed and lagframes <=0 and not dodging:
		if Input.is_action_just_pressed(light_attack) or\
			Input.is_action_just_pressed(grab) or\
			Input.is_action_just_pressed(med_attack) :
			pummel()


		
func lAttack():
	lagframes = 9 #1 start up, 5 active frames, 3 endlag frames
	await(wait(frames_to_seconds(5)))
	createHitbox(10,-10,20,20,5,10,10,.9,50)
func mAttack():
	lagframes = 40 #10 start up, 20 active frames, 10 endlag frames
	
	await(wait(frames_to_seconds(10)))
	createHitbox(10,-10,15,20,5,5,1,.1, 100)
	await(wait(frames_to_seconds(5)))
	createHitbox(10,-20,15,10,10,0,0,.1,35)
	await(wait(frames_to_seconds(10)))
	createHitbox(10,-10,15,20,5,5,-2,0,50)
	await(wait(frames_to_seconds(5)))
	createHitbox(10,10,15,5,5,10,30,.9,50)
func pummel(): 
	lagframes = 20
	createHitbox(0,-10,20,20,15,1,0,1,0)
func grabAttack():
	lagframes = 20 #5 start up, 10 active frames, 5 endlag frames
	await(wait(frames_to_seconds(5)))
	createGrabBox(10,-5,20,10,10,2*Engine.get_frames_per_second())
func _on_area_2d_area_entered(area):
	platformCalc(area)
	deathBoxCheck(area)
	if not dodging:
		grabBoxCheck(area)
		knockBackCalculations(area)

func frames_to_seconds(frames):
	print(frames * deltaG)
	return frames * deltaG
