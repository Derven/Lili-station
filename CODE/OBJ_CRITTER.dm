// /obj/critter vars
//---------------------
/obj/critter/name = "critter"
/obj/critter/desc = "you shouldnt be able to see this"
/obj/critter/icon = 'critter.dmi'
/obj/critter/layer = 5.0
/obj/critter/density = 1
/obj/critter/anchored = 0
/obj/critter/var/alive = 1
/obj/critter/var/health = 10
/obj/critter/var/task = "thinking"
/obj/critter/var/aggressive = 0
/obj/critter/var/defensive = 0
/obj/critter/var/wanderer = 1
/obj/critter/var/opensdoors = 0
/obj/critter/var/frustration = 0
/obj/critter/var/last_found = null
/obj/critter/var/target = null
/obj/critter/var/oldtarget_name = null
/obj/critter/var/target_lastloc = null
/obj/critter/var/atkcarbon = 0
/obj/critter/var/atksilicon = 0
/obj/critter/var/atcritter = 0
/obj/critter/var/attack = 0
/obj/critter/var/attacking = 0
/obj/critter/var/steps = 0
/obj/critter/var/firevuln = 1
/obj/critter/var/brutevuln = 1
/obj/critter/var/seekrange = 7 // how many tiles away it will look for a target
/obj/critter/var/friend = null // used for tracking hydro-grown monsters's creator
/obj/critter/var/attacker = null // used for defensive tracking
/obj/critter/var/angertext = "charges at" // comes between critter name and target name

// /obj/critter procs
//---------------------
/obj/critter/New()
		spawn(0) process()
		..()

/obj/critter/process()
	if (!src.alive) return
	check_health()
	switch(task)
		if("thinking")
			src.attack = 0
			src.target = null
			sleep(15)
			walk_to(src,0)
			if (src.aggressive) seek_target()
			if (src.wanderer && !src.target) src.task = "wandering"
		if("chasing")
			if (src.frustration >= 8)
				src.target = null
				src.last_found = world.time
				src.frustration = 0
				src.task = "thinking"
				walk_to(src,0)
			if (target)
				if (get_dist(src, src.target) <= 1)
					var/mob/M = src.target
					ChaseAttack(M)
					src.task = "attacking"
					src.anchored = 1
					src.target_lastloc = M.loc
				else
					var/turf/olddist = get_dist(src, src.target)
					walk_to(src, src.target,1,4)
					if(istype(src, /obj/critter/killertomato/fox_on_bike/syndi1) || istype(src, /obj/critter/killertomato/fox_on_bike/syndi2))
						if(prob(45))
							for(var/mob/M in range(7,src))
								M.playsoundforme('Laser22.ogg')
							var/mob/M = src.target
							dir = turn(M.dir, 180)
							var/obj/item/projectile/beam/A
							if(prob(35))
								A = new /obj/item/projectile/beam/explosive(src.loc)
								A.dest = M
							else
								A = new /obj/item/projectile/beam(src.loc)
								A.dest = M
							A.firer = src
							A.dir = dir
							A.process()
					if ((get_dist(src, src.target)) >= (olddist))
						src.frustration++
					else
						src.frustration = 0
					sleep(5)
			else src.task = "thinking"
		if("attacking")
			// see if he got away
			if ((get_dist(src, src.target) > 1) || ((src.target:loc != src.target_lastloc)))
				src.anchored = 0
				src.task = "chasing"
			else
				if (get_dist(src, src.target) <= 1)
					var/mob/M = src.target
					if (!src.attacking) CritterAttack(src.target)
					if (!src.aggressive)
						src.task = "thinking"
						src.target = null
						src.anchored = 0
						src.last_found = world.time
						src.frustration = 0
						src.attacking = 0
					else
						if(M!=null)
							if (M.death != 0)
								src.task = "thinking"
								src.target = null
								src.anchored = 0
								src.last_found = world.time
								src.frustration = 0
								src.attacking = 0
				else
					src.anchored = 0
					src.attacking = 0
					src.task = "chasing"
		if("wandering")
			patrol_step()
			sleep(10)
	spawn(8)
		process()
	return

/obj/critter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (!src.alive)
		..()
		return
	switch(W.damtype)
		if("fire")
			src.health -= W.force * src.firevuln
		if("brute")
			src.health -= W.force * src.brutevuln
		else
	if (src.alive && src.health <= 0) src.CritterDeath()
	if (src.defensive)
		src.target = usr
		//src.oldtarget_name = user.name
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> [src.angertext] [usr.name]!", 1)
		src.task = "chasing"

/obj/critter/attack_hand(var/mob/user as mob)
	..()
	if (!src.alive)
		..()
		return
	if (usr.intent == 0)
		src.health -= rand(1,2) * src.brutevuln
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[usr]</b> punches [src]!", 1)
		if (src.alive && src.health <= 0) src.CritterDeath()
		if (src.defensive)
			src.target = user
			src.oldtarget_name = usr.name
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> [src.angertext] [usr.name]!", 1)
			src.task = "chasing"
	else
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[usr]</b> pets [src]!", 1)

/obj/critter/Bumped(M as mob|obj|turf)
	spawn(0)
		var/turf/T = get_turf(src)
		M:loc = T

/obj/critter/ex_act(severity)
	switch(severity)
		if(1.0)
			src.CritterDeath()
			return
		if(2.0)
			src.health -= 15
			if (src.health <= 0)
				src.CritterDeath()
			return
		else
			src.health -= 5
			if (src.health <= 0)
				src.CritterDeath()
			return
	return

/obj/critter/Bump(var/atom/M)
	spawn(0)
		if(istype(M, /turf/simulated/wall/window))
			var/turf/simulated/wall/window/WIN = M
			for(var/mob/A in range(5, M))
				A.playsoundforme('Glasshit.ogg')
			WIN.health -= rand(15, 25)
			WIN.update_icon()
		if ((istype(M, /obj/machinery/airlock)))
			if(!istype(src, /obj/critter/killertomato))
				var/obj/machinery/airlock/D = M
				if (src.opensdoors)
					if(D.charge == 0)
						return
					if(D.close)
						D.open()
					else
						D.close()
					src.frustration = 0
				else src.frustration ++
		else if ((istype(M, /mob/)) && (!src.anchored))
			src.loc = M:loc
			src.frustration = 0
		return
	return

/obj/critter/proc/patrol_step()
	var/moveto = locate(src.x + rand(-1,1),src.y + rand(-1, 1),src.z)
	if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(src, moveto)
	if(istype(src, /obj/critter/killertomato/fox_on_bike/syndi1) || istype(src, /obj/critter/killertomato/fox_on_bike/syndi2))
		if (istype(moveto, /turf/space)) step_towards(src, moveto)
	if(src.aggressive) seek_target()
	steps += 1
	if (steps == rand(5,20)) src.task = "thinking"

/obj/critter/proc/check_health()
	if (src.health <= 0)
		src.CritterDeath()


/obj/critter/proc/seek_target()
	src.anchored = 0
	for (var/mob/C in view(src.seekrange,src))
		if (src.target)
			src.task = "chasing"
			break
		if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
		if (istype(C, /mob) && !src.atkcarbon) continue
		if (C.death != 0) continue
		if (C.name == src.friend) continue
		if (C.name == src.attacker) src.attack = 1
		if (istype(C, /mob/) && src.atkcarbon) src.attack = 1

		if (src.attack)
			src.target = C
			src.oldtarget_name = C.name
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <b>[src]</b> [src.angertext] [C.name]!", 1)
			src.task = "chasing"
			break
		else
			continue

/obj/critter/proc/CritterDeath()
	if (!src.alive) return
	src.icon_state += "-dead"
	src.alive = 0
	src.anchored = 0
	src.density = 0
	walk_to(src,0)

/obj/critter/proc/ChaseAttack(mob/M)
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[src]</B> leaps at [src.target]!", 1)
	//////playsound(src.loc, 'sound/weapons/genhit1.ogg', 50, 1, -1)

/obj/critter/proc/CritterAttack(mob/simulated/living/M)
	src.attacking = 1
	M = src.target
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
	M.rand_damage(2, 8)
	spawn(25)
		src.attacking = 0

/obj/critter/proc/CritterTeleport(var/telerange, var/dospark, var/dosmoke)
	if (!src.alive) return
	var/list/randomturfs = new/list()
	for(var/turf/T in orange(src, telerange))
		if(istype(T, /turf/space) || T.density) continue
		randomturfs.Add(T)
	src.loc = pick(randomturfs)
	src.task = "thinking"