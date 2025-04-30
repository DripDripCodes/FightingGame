extends Fighter

#Lokilani movement ability detaches legs, can 1. recall to legs or have legs recall to her 
#Note to self, add 1 second art. load time to start of match
var attack_queued = ""
var deltaG = 0
func _ready():
	super()
	
func _process(delta):
	deltaG = delta
	if dodging:
		$CollisionShape.debug_color = Color.ALICE_BLUE
	else:
		match player_value:
			1:
				$CollisionShape.debug_color = Color.PINK
			2:
				$CollisionShape.debug_color = Color.BLUE
	if not grabbing and not grabbed and cooldown <=  0 and lagframes <=0:
		if Input.is_action_just_pressed(light_attack):
			lAttack()
		if Input.is_action_just_pressed(med_attack):
			mAttack()
		if Input.is_action_just_pressed(grab):
			grabAttack()
	if grabbing:
		if Input.is_action_just_pressed(light_attack) or\
			Input.is_action_just_pressed(grab):
			pummel()


		
func lAttack():
	lagframes = 9 #1 start up, 5 active frames, 3 endlag frames
	await(wait(frames_to_seconds(5)))
	createHitbox(0,-10,20,20,5,10,10,.9,50)
func mAttack():
	lagframes = 40 #10 start up, 20 active frames, 10 endlag frames
	
	await(wait(frames_to_seconds(10)))
	createHitbox(10,-10,15,20,5,5,1,.1, 100)
	await(wait(frames_to_seconds(5)))
	createHitbox(10,-20,15,10,15,0,0,.1,35)
	await(wait(frames_to_seconds(10)))
	createHitbox(10,-10,15,20,5,5,-2,0,50)
	await(wait(frames_to_seconds(5)))
	createHitbox(10,5,15,5,5,10,30,.9,50)
func pummel(): 
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
	return frames * deltaG
