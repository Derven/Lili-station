/obj/effect/expl_particles
	name = "fire"
	icon = 'effects.dmi'
	icon_state = "explosion_particle"
	opacity = 1
	anchored = 1
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

/obj/effect/explosion
	name = "fire"
	icon = 'effects.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/New()
	..()
	spawn (10)
		del(src)
	return

/datum/effect/system/explosion
	var/turf/location

/datum/effect/system/explosion/proc/set_up(loca)
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/explosion/proc/start()
	new/obj/effect/explosion( location )
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10,location)
	P.start()

var/roundExplosions = 1

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	if(!epicenter) return
	spawn(0)
		if(defer_powernet_rebuild != 2)
			defer_powernet_rebuild = 1
		if (!istype(epicenter, /turf))
			epicenter = get_turf(epicenter.loc)
		for(var/mob/M in range(8, epicenter))
			M << 'explosionfar.ogg'

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/list/exTurfs = list()

		if(roundExplosions)
			for(var/turf/T in range(epicenter,light_impact_range))
				exTurfs += T
		else
			for(var/turf/T in range(light_impact_range, epicenter))
				exTurfs += T

		for(var/turf/T in exTurfs)
			var/distance = 0
			distance = get_dist(epicenter, T)
			if(distance < 0)
				distance = 0
			if(distance < devastation_range)
				for(var/atom/object in T.contents)
					spawn()
						if(object)
							object.ex_act(1)
				if(prob(5))
					if(T)
						T.ex_act(2)
				else
					if(T)
						T.ex_act(1)
			else if(distance < heavy_impact_range)
				for(var/atom/object in T.contents)
					spawn()
						if(object)
							object.ex_act(2)
				if(T)
					T.ex_act(2)
			else if (distance == heavy_impact_range)
				for(var/atom/object in T.contents)
					if(object)
						object.ex_act(2)
				if(prob(15) && devastation_range > 2 && heavy_impact_range > 2)
					secondaryexplosion(T, 1)
				else
					if(T)
						T.ex_act(2)
			else if(distance <= light_impact_range)
				for(var/atom/object in T.contents)
					spawn()
						if(object)
							object.ex_act(3)
				if(T)
					T.ex_act(3)

		sleep(-1)
		sleep(20)
		if(defer_powernet_rebuild != 2)
			defer_powernet_rebuild = 0
	return 1



proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)