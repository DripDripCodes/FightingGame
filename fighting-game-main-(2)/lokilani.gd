extends Fighter

func _ready():
	super()
	
func _process(delta):
	if Input.is_action_just_pressed(light_attack):
		lAttack()
	if not grabbing:
		if Input.is_action_just_pressed(grab):
			grabAttack()
	if grabbing:
		if Input.is_action_just_pressed(light_attack) or\
			Input.is_action_just_pressed(grab):
			pummel()
func lAttack():
	createHitbox(0,-10,20,20,15,10,10,.9)
func pummel():
	createHitbox(0,-10,20,20,15,1,0,1)
	
func grabAttack():
	createGrabBox(10,-5,20,10,10,120)
func _on_area_2d_area_entered(area):
	knockBackCalculations(area)
	platformCalc(area)
	deathBoxCheck(area)
	grabBoxCheck(area)
