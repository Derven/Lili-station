/mob
	var/bruteloss = 0.0//Living
	var/fireloss = 0.0//Living

	proc/switch_intent()
		if(intent)
			intent = 0
			return
		else
			intent = 1
			return

