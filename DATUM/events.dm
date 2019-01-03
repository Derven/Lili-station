var/datum/events/fun


/datum/events
	var/cur_event = "no"
	var/list/eventslist = list("syndi sabotage", "meteor", "nopower", "no")

	proc/myevents()
		spawn while(1)
			sleep(rand(400, 650))
			cur_event = pick(eventslist)
			world << 'alert.ogg'
			switch(cur_event)
				if("syndi sabotage")
					world << "\red Central Command reports a possible attack!"
				if("meteor")
					world << "\red Meteor alert!"
					var/obj/meteorspawn = pick(meteormarks)
					boom(rand(3,5), meteorspawn.loc)
				if("nopower")
					world << "\red Abnormal activity detected in lili station's powernet."
					for(var/obj/machinery/simple_smes/S in world)
						S.charge = 0

	New()
		..()
		myevents()

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
		if(istype(A, /turf/simulated/wall))
			invisibility = 101
			nuc_boom(70, A)
			sleep(60)
			world.Reboot()