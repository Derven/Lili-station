/obj/effect/expl_particles
	name = "fire"
	icon = 'explode.dmi'
	icon_state = "flick"
	opacity = 1
	anchored = 1
	layer = 25
	mouse_opacity = 0

/obj/effect/expl_particles/New()
	..()
	spawn (15)
		del(src)
	return

/obj/effect/expl_particles/Move()
	..()
	return

/datum/effect/system/expl_particles
	var/number = 10
	var/turf/location
	var/total_particles = 0

/datum/effect/system/expl_particles/proc/set_up(n = 10, loca)
	number = n
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/expl_particles/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			var/obj/effect/expl_particles/expl = new /obj/effect/expl_particles(src.location)
			var/direct = pick(alldirs)
			for(i=0, i<pick(1;25,2;50,3,4;200), i++)
				sleep(1)
				step(expl,direct)

/atom/movable
	proc/force_to(var/value_of_force, var/dir_of_force)
		var/turf/T2 = get_step(src, dir_of_force)
		while(value_of_force > 0 && (!(istype(T2, /turf/simulated/wall))))
			sleep(2)
			Move(get_step(src, dir_of_force))
			value_of_force -= rand(1,3)
			if(value_of_force < 0)
				value_of_force = 0

	proc/force_all_directions(var/mydir, var/value)
		if(mydir == 1)
			src.force_to(value, NORTH)

		if(mydir == 2)
			src.force_to(value, SOUTH)

		if(mydir == 4)
			src.force_to(value, EAST)

		if(mydir == 8)
			src.force_to(value, WEST)

proc/boom(irange, epcntr)
	new /obj/effect/expl_particles(epcntr)
	for(var/atom/A in range(irange, epcntr))
		if(!istype(A, /area))
			if(istype(A, /obj))
				var/obj/M = A
				if(prob(65))
					if(M.anchored == 1)
						if(prob(45))
							M.anchored = 0
					else
						var/i = rand(2,4)
						while(i > 0)
							i--
							new /obj/effect/smoke(locate(M.x + rand(-2,2), M.y + rand(-2,2), M.z))
						M.ex_act()
					for(var/mob/MOB in range(5, M))
						MOB << "<b>[M] flew away!</b>"
					if(A)
						M.force_all_directions(turn(get_dir(A.loc,epcntr), 180), irange * 2)
			else
				A.ex_act()

proc/nuc_boom(irange, epcntr)
	new /obj/effect/expl_particles(epcntr)
	for(var/atom/A in range(irange, epcntr))
		if(!istype(A, /area))
			A.ex_act()

/atom
	var/robustness = 5
