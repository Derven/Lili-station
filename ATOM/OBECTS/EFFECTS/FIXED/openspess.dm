/obj/spess
	icon = 'floors.dmi'
	icon_state = "openspess"
	anchored = 1

	Crossed(var/atom/movable/M)
		if(z != 1)
			M.z -= 1
			if(istype(M, /mob/simulated/living/humanoid/human))
				var/mob/simulated/living/humanoid/human/O = M
				O.rand_damage(5, 15)

	New()
		..()
		for(var/obj/spess/O in loc)
			if(O != src)
				del(O)
		loc.icon_state = null
		layer = loc.layer + 2
		if(z > 1)
			var/turf/simulated/T = locate(x, y, z-1)
			var/image/T2 = image(T.icon, T.icon_state)
			T2.pixel_z = -32
			T2.layer = loc.layer -1
			underlays += T2
			for(var/obj/O in T)
				var/image/A = image(O.icon, O.icon_state)
				A.pixel_z = -32
				underlays += A

	process()
		sleep(rand(3,5))
		underlays.Cut()
		if(z > 1)
			var/turf/simulated/T = locate(x, y, z-1)
			var/image/T2 = image(T.icon, T.icon_state)
			T2.pixel_z = -32
			T2.layer = loc.layer -1
			underlays += T2
			for(var/obj/O in T)
				var/image/A = image(O.icon, O.icon_state)
				A.pixel_z = -32
				underlays += A
