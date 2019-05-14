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

/obj/effect/smoke
	icon='effects.dmi'
	icon_state = "smoke"
	layer = 15
	opacity = 1

	New()
		..()
		spawn(rand(8,15))
			del(src)