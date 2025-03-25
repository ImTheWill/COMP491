extends Control
@onready var HealthBar1 = $HealthBar1
@onready var HealthBar2 = $HealthBar2


func change_health(newValue):
	var oldVal = HealthBar2.value
	var styleBox: StyleBox = HealthBar1.get_theme_stylebox("fill")
	
	if newValue>0 :
		HealthBar1.value =oldVal+newValue
		styleBox.bg_color = Color("1a340b")
		fill_change(HealthBar2, newValue)
	elif newValue<0:
		HealthBar2.value = oldVal+newValue
		styleBox.bg_color = Color("ca0020")
		fill_change(HealthBar1, newValue)
	HealthBar1.add_theme_stylebox_override("fill", styleBox)
	
	
	
func fill_change(healthBar, changeVal):
	for i in abs(changeVal):
		await get_tree().create_timer(0.05).timeout
		if changeVal < 0: healthBar.value -=1
		elif changeVal >  0: healthBar.value +=1
