/obj/effect/sparks
	icon='effects.dmi'
	icon_state = "sparks"
	layer = 15

	New()
		..()
		dir = rand(1,4)
		pixel_x = rand(1,8)
		pixel_y = rand(1,8)
		sleep(rand(2,5))
		del(src)

/obj/effect/bloodyblood
	icon='blood.dmi'
	icon_state = "humanblood"
	layer = 25

	New()
		..()
		sleep(rand(2,5))
		del(src)


/obj/effect/smoke
	icon='effects.dmi'
	icon_state = "smoke"
	layer = 15
	opacity = 1

	New()
		..()
		spawn(rand(8,15))
			del(src)

/obj/effect/flame
	icon='effects.dmi'
	icon_state = "flame"
	layer = 15
	opacity = 1

	Crossed(var/mob/simulated/living/L)
		if(istype(L, /mob/simulated/living/humanoid/human))
			L.rand_burn_damage(50, 150)
		else
			L.health -= rand(70, 120)

	New()
		..()
		spawn(3)
			for(var/mob/simulated/living/M in src.loc)
				if(istype(M, /mob/simulated/living/humanoid/human))
					M.rand_burn_damage(50, 150)
				else
					M.health -= rand(70, 120)
			for(var/obj/plant/P in range(1, src))
				del(P)
			for(var/obj/critter/C in range(1, src))
				C.health -= rand(5, 45)
			src.loc:hotspot_expose(1000,500,1)
			spawn(9)
				del(src)