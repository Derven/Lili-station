// p much straight up copied from secbot code =I

/atom/proc/show_message(var/msg)
	src << msg

/obj/critter/
	name = "critter"
	desc = "you shouldnt be able to see this"
	icon = 'critter.dmi'
	layer = 5.0
	density = 1
	anchored = 0
	var/alive = 1
	var/health = 10
	var/task = "thinking"
	var/aggressive = 0
	var/defensive = 0
	var/wanderer = 1
	var/opensdoors = 0
	var/frustration = 0
	var/last_found = null
	var/target = null
	var/oldtarget_name = null
	var/target_lastloc = null
	var/atkcarbon = 0
	var/atksilicon = 0
	var/atcritter = 0
	var/attack = 0
	var/attacking = 0
	var/steps = 0
	var/firevuln = 1
	var/brutevuln = 1
	var/seekrange = 7 // how many tiles away it will look for a target
	var/friend = null // used for tracking hydro-grown monsters's creator
	var/attacker = null // used for defensive tracking
	var/angertext = "charges at" // comes between critter name and target name

	attackby(obj/item/weapon/W as obj, mob/user as mob)
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

	attack_hand(var/mob/user as mob)
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

	proc/patrol_step()
		var/moveto = locate(src.x + rand(-1,1),src.y + rand(-1, 1),src.z)
		if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(src, moveto)
		if(istype(src, /obj/critter/killertomato/fox_on_bike/syndi1) || istype(src, /obj/critter/killertomato/fox_on_bike/syndi2))
			if (istype(moveto, /turf/space)) step_towards(src, moveto)
		if(src.aggressive) seek_target()
		steps += 1
		if (steps == rand(5,20)) src.task = "thinking"

	Bump(var/atom/M)
		spawn(0)
			if(istype(M, /turf/simulated/wall/window))
				var/turf/simulated/wall/window/WIN = M
				for(var/mob/A in range(5, M))
					A.playsoundforme('Glasshit.ogg')
				WIN.health -= rand(15, 25)
				WIN.update_icon()
			if ((istype(M, /obj/machinery/airlock)))
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

	Bumped(M as mob|obj|turf)
		spawn(0)
			var/turf/T = get_turf(src)
			M:loc = T
/*	Strumpetplaya - Not supported
	bullet_act(var/datum/projectile/P)
		var/damage = 0
		damage = round((P.power*P.ks_ratio), 1.0)

		if((P.damage_type == D_KINETIC)||(P.damage_type == D_PIERCING)||(P.damage_type == D_SLASHING))
			src.health -= (damage*brutevuln)
		else if(P.damage_type == D_ENERGY)
			src.health -= damage
		else if(P.damage_type == D_BURNING)
			src.health -= (damage*firevuln)
		else if(P.damage_type == D_RADIOACTIVE)
			src.health -= 1
		else if(P.damage_type == D_TOXIC)
			src.health -= 1

		if (src.health <= 0)
			src.CritterDeath()
*/
	ex_act(severity)
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

	proc/check_health()
		if (src.health <= 0)
			src.CritterDeath()

	process()
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
								else
									A = new /obj/item/projectile/beam(src.loc)
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


	New()
		spawn(0) process()
		..()

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


//
// Critter Defines
//

/obj/critter/roach
	name = "cockroach"
	desc = "An unpleasant insect that lives in filthy places."
	icon_state = "roach"
	health = 10
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0

	attack_hand(mob/usr as mob)
		if (src.alive && (usr.intent != 1))
			usr << "\red <b>[usr]</b> pets [src]!"
			return
		if(prob(95))
			usr << "\red <B>[usr] stomps [src], killing it instantly!</B>"
			CritterDeath()
			return
		..()

/obj/critter/maneater
	name = "man-eating plant"
	desc = "It looks hungry..."
	icon_state = "maneater"
	density = 1
	health = 30
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 0
	firevuln = 2
	brutevuln = 0.5

	New()
		..()
		//////playsound(src.loc, pick('MEilive.ogg'), 50, 0)	Strumpetplaya - Not supported

	seek_target()
		src.anchored = 0
		for (var/mob/C in view(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (istype(C, /mob/) && !src.atkcarbon) continue
			if (C.job == "botanist") continue
			if (C.death != 0) continue
			if (C.name == src.friend) continue
			if (istype(C, /mob/) && src.atkcarbon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> charges at [C.name]!", 1)
				//////playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else continue

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> slams into [M]!", 1)
		////playsound(src.loc, 'sound/weapons/genhit1.ogg', 50, 1, -1)

	CritterAttack(mob/simulated/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> starts trying to eat [M]!", 1)
		spawn(60)
			if (get_dist(src, M) <= 1 && ((M:loc == target_lastloc)))
				if(istype(M,/mob))
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <B>[src]</B> ravenously wolfs down [M]!", 1)
					////playsound(src.loc, 'sound/items/eatfood.ogg', 30, 1, -2)
					M.death(1)
					M.icon = null
					M.invisibility = 101
					del(M)
					sleep(25)
					src.target = null
					src.task = "thinking"
					//////playsound(src.loc, pick('burp_alien.ogg'), 50, 0)	Strumpetplaya - Not supported
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[src]</B> gnashes its teeth in fustration!", 1)
			src.attacking = 0

/obj/critter/killertomato
	name = "killer tomato"
	desc = "Today, Space Station 13 - tomorrow, THE WORLD!"
	icon_state = "ktomato"
	density = 1
	health = 15
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 2
	brutevuln = 2

	seek_target()
		src.anchored = 0
		for (var/mob/C in view(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (istype(C, /mob/) && !src.atkcarbon) continue
			if (C.death != 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (istype(C, /mob) && src.atkcarbon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> charges at [C:name]!", 1)
				//////playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/simulated/living/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> viciously lunges at [M]!", 1)
		M.rand_damage(5, 15)

	CritterAttack(mob/simulated/living/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		M.rand_damage(7, 15)
		spawn(10)
			src.attacking = 0

	CritterDeath()
		for(var/mob/M in range(3, src))
			M << "<b>[src]</b> messily splatters into a puddle of tomato sauce!"
		src.alive = 0
		////playsound(src.loc, 'sound/effects/splat.ogg', 100, 1)
		var/obj/blood/B = new(src.loc)
		B.name = "ruined tomato"
		del src

/obj/critter/spore
	name = "plasma spore"
	desc = "A barely intelligent colony of organisms. Very volatile."
	icon_state = "spore"
	density = 1
	health = 1
	aggressive = 0
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 2
	brutevuln = 2

	CritterDeath()
		src.alive = 0
		var/turf/T = get_turf(src.loc)
		if(T)
			T.hotspot_expose(700,125)
			boom(rand(2,4), T)
		del src

	ex_act(severity)
		CritterDeath()

	bullet_act(flag, A as obj)
		CritterDeath()

/obj/critter/mouse
	name = "space-mouse"
	desc = "A mouse.  In space."
	icon_state = "mouse"
	density = 0
	health = 2
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += 1
		spawn(10)
			src.attacking = 0

/obj/critter/killertomato/fox_on_bike
	icon_state = "fox"
	name="plinfox"

	New()
		..()
		process()

	syndi1
		icon_state = "syndi1"
		name="syndicate soldier"
		seekrange = 14

		bullet_act(var/obj/item/projectile/Proj)
			if(Proj.firer != src)
				health -= rand(Proj.damage - rand(1,4), Proj.damage)
				del(Proj)
			return 0

		CritterAttack(mob/simulated/living/M)
			src.attacking = 1
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[src]</B> attacks [src.target] with lightsaber!", 1)
			M.rand_damage(8, 19)
			spawn(10)
				src.attacking = 0

		seek_target()
			src.anchored = 0
			for (var/mob/C in view(src.seekrange,src))
				if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
				if (istype(C, /mob/) && !src.atkcarbon) continue
				if (C.death != 0) continue
				if (C.name == src.attacker) src.attack = 1
				if (istype(C, /mob) && src.atkcarbon) src.attack = 1

				if (src.attack)
					src.target = C
					src.oldtarget_name = C.name
					//////playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
					src.task = "chasing"
					break
				else
					continue

	syndi2
		icon_state = "syndi2"
		name="syndicate soldier"
		seekrange = 14

		bullet_act(var/obj/item/projectile/Proj)
			if(Proj.firer != src)
				health -= rand(Proj.damage - rand(1,4), Proj.damage)
				del(Proj)
			return 0

		CritterAttack(mob/simulated/living/M)
			src.attacking = 1
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[src]</B> attacks [src.target] with lightsaber!", 1)
			M.rand_damage(4, 15)
			spawn(10)
				src.attacking = 0

		seek_target()
			src.anchored = 0
			for (var/mob/C in view(src.seekrange,src))
				if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
				if (istype(C, /mob/) && !src.atkcarbon) continue
				if (C.death != 0) continue
				if (C.name == src.attacker) src.attack = 1
				if (istype(C, /mob) && src.atkcarbon) src.attack = 1

				if (src.attack)
					src.target = C
					src.oldtarget_name = C.name
					//////playsound(src.loc, pick('MEhunger.ogg', 'MEraaargh.ogg', 'MEruncoward.ogg', 'MEbewarecoward.ogg'), 50, 0)	Strumpetplaya - Not supported
					src.task = "chasing"
					break
				else
					continue

/obj/critter/mimic
	name = "mechanical toolbox"
	desc = null
	icon_state = "mimic1"
	health = 20
	aggressive = 1
	defensive = 1
	wanderer = 0
	atkcarbon = 1
	atksilicon = 1
	brutevuln = 0.5
	seekrange = 1
	angertext = "suddenly comes to life and lunges at"

	process()
		..()
		if (src.alive)
			switch(task)
				if("thinking")
					src.icon_state = "mimic1"
					src.name = "mechanical toolbox"
				if("chasing")
					src.icon_state = "mimic1"
					src.name = "mimic"
				if("attacking")
					src.icon_state = "mimic2"
					src.name = "mimic"

	ChaseAttack(mob/M)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> hurls itself at [M]!", 1)

	CritterAttack(mob/M)
		src.attacking = 1
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> bites [src.target]!", 1)
		src.target:bruteloss += rand(2,4)
		spawn(25)
			src.attacking = 0

	CritterDeath()
		src.alive = 0
		density = 0
		walk_to(src,0)
		src.icon_state = "mimic-dead"