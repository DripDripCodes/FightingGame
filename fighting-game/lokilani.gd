extends Fighter


func _ready():
	super()
	
func _process(delta):
	if Input.is_action_just_pressed(light_attack):
		lAttack()
		
func lAttack():
	createHitbox(0,-10,20,20,15,0,10,.9)
	
func _on_area_2d_area_entered(area):
	knockBackCalculations(area)
	platformCalc(area)
	
