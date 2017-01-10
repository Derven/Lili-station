/mob/proc/resting()
	if(!lying)
		src.transform = turn(src.transform, 90)
		lying = 1
		return
	else
		src.transform = turn(src.transform, -90)
		lying = 0
		return

/mob/verb/rest()
	resting()
