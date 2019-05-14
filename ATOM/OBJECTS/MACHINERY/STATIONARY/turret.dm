/obj/machinery/turret
	icon = 'stationobjs.dmi'
	icon_state = "gun1"
	density = 1
	anchored = 1

	verb/rotate()
		set src in view(1)
		dir = turn(dir, 90)

	attack_hand()
		sleep(4)
		var/guncharge = 0
		for(var/obj/machinery/simple_apc/SA in range(8, src))
			SA.charge = SA.charge - 3200
			guncharge = SA.charge + 3200
		if(guncharge > 3200)
			var/i = 3
			while(i > 0)
				for(var/mob/M in range(5,src))
					M.playsoundforme('Laser22.ogg')
				i -= 1
				sleep(rand(1,2))
				var/obj/item/projectile/beam/particles/A = new /obj/item/projectile/beam/particles(src.loc)
				A.dir = dir
				A.process()