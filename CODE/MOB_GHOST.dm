// /mob/ghost vars
//---------------------
/mob/ghost/invisibility = 75
/mob/ghost/alpha = 128
/mob/ghost/see_invisible = 101
/mob/ghost/see_infrared = 1
/mob/ghost/density = 0
/mob/ghost/death = 1
/mob/ghost/var/power = 100
//---------------------

// /mob/ghost procs
//---------------------

/mob/ghost/New()
	..()
	sight |= SEE_THRU

/mob/ghost/process()
	..()
	if(prob(5))
		if(power < 100)
			power++

/mob/ghost/verb/boo()
	if(power >= 100)
		power = 0
		invisibility = 0
		spawn(15)
			invisibility = 101