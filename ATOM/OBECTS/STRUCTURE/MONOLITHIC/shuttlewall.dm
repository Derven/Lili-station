/obj/structure/shuttlewall
	anchored = 1
	density = 1
	icon ='walls.dmi'
	icon_state = "shuttle"

	var/opened = 0

	proc/dump_contents()
		for(var/obj/item/I in src)
			I.loc = src.loc

		for(var/mob/M in src)
			M.loc = src.loc
			if(M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE


	proc/toggle()
		if(src.opened)
			return src.close()
		return src.open()

	proc/open()
		for(var/mob/M in range(5, src))
			M.playsoundforme('bin_open.ogg')
		if(src.opened)
			return 0

		src.dump_contents()

		src.opened = 1
		////playsound(src.loc, 'click.ogg', 15, 1, -3)
		density = 0
		return 1

	proc/close()
		for(var/mob/M in range(5, src))
			M.playsoundforme('bin_open.ogg')
		if(!src.opened)
			return 0

		for(var/obj/item/I in src.loc)
			if(!I.anchored)
				I.loc = src

		for(var/mob/M in src.loc)
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

			M.loc = src
		src.opened = 0
		////playsound(src.loc, 'click.ogg', 15, 1, -3)
		density = 1
		return 1

	attack_hand(mob/user as mob)
		if(!src.toggle())
			usr << "\blue It won't budge!"