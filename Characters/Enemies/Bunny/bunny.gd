extends characterBasic
class_name enemy_bunny

func _on_think_timer_timeout() -> void:
	super()
	#if current_state.stateName == "attackReady":
	#	warning.visible = true
	#else:
	#	warning.visible = false
		
	if current_state.stateName == "idle":
		moving = false
		attacking = false
	if current_state.stateName == "run":
		randomMove()
		moving = true
		attacking = false
	if current_state.stateName == "attack":
		attacking = true
		moving = true
