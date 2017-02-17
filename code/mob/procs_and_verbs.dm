/mob/proc/resting()
	if(!lying)
		src.transform = turn(src.transform, 90)
		lying = 1
		density = 0
		return
	else
		if(death == 0)
			src.transform = turn(src.transform, -90)
			density = 1
			lying = 0
			return

/mob/verb/rest()
	resting()

/mob/verb/miracle()
	death = 0
	reagents.add_reagent("blood", 200)
	heal_brute(80)

/mob/ghost
	invisibility = 100
	alpha = 128
	see_invisible = 101
	density = 0
	death = 1