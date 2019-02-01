/obj/machinery/portable_machinery
	icon = 'stationobjs.dmi'
	name = "portable machinery"
	icon_state = "portable_machinery"
	density = 1
	anchored = 0
	var/datum/emodule/central/basic_power_controller/socket_1
	var/datum/emodule/central/basic_power_controller/socket_2
	var/datum/emodule/central/basic_power_controller/socket_3


	Bump(var/atom/A)
		if(istype(A, /obj/machinery/airlock))
			var/obj/machinery/airlock/A_LOCK = A
			var/turf/simulated/floor/T = A.loc
			if(A_LOCK.charge == 0)
				return
			else
				if(A_LOCK.close)
					A_LOCK.open()
				else
					A_LOCK.close()
				if(istype(A.loc, /turf/simulated))
					T.update_air_properties()
		else
			return 1


	process()
		socket_1.myprocess()
		socket_2.myprocess()
		socket_3.myprocess()

	New()
		socket_1 = new /datum/emodule/central/basic_power_controller(src)
		socket_2 = new /datum/emodule/central/basic_power_controller(src)
		socket_3 = new /datum/emodule/central/basic_power_controller(src)
		..()

	cratebot
		icon_state = "cratebot"
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