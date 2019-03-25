/mob/ghost
	invisibility = 75
	alpha = 128
	see_invisible = 101
	see_infrared = 1
	density = 0
	death = 1
	var/power = 100

	New()
		..()
		sight |= SEE_THRU

	process()
		..()
		if(prob(5))
			if(power < 100)
				power++

	verb/boo()
		if(power >= 100)
			power = 0
			invisibility = 0
			spawn(15)
				invisibility = 101