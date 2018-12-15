/obj/machinery/nuka
	icon = 'nuclear_bomb.dmi'
	density = 1

	New()
		..()
		world << "\red <h1>Nuclear alert! Duck and cover!</h1>"
		world << 'bomb.ogg'
		for(var/mob/M in world)
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

		START_PROCESSING(SSobj, src)

	process()
		Move(locate(x+1, y - 1, z))

	Bump(var/atom/A)
		if(istype(A, /turf/unsimulated/wall))
			nuc_boom(70, A)
			layer = 0
			sleep(60)
			world.Reboot()