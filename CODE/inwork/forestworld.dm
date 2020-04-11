/obj/tree
	icon = 'big_decor.dmi'
	icon_state = "forest1"
	density = 0
	plane = 70
	mouse_opacity = 0

	New()
		..()
		if(prob(rand(35,85)))
			del(src)
		else
			var/rand1 = rand(25,55)
			var/rand2 = rand(45,87)
			if(rand1 > rand2)
				alpha = alpha - rand1
			else
				alpha = alpha - rand2

/obj/radioactive_barrel
	icon_state = "radioactive_tank"
	icon = 'stationobjs.dmi'
	anchored = 1
	density = 1

	New()
		..()
		dir = pick(1,2,4,8)
		START_PROCESSING(SSobj, src)

	process()
		for(var/mob/simulated/living/humanoid/H in range(2, src))
			if(prob(30))
				H.rand_damage(6, 8)