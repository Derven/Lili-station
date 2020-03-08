//
// Critter Defines
//
var/list/obj/spidermarks = list()

proc/SpawnSpiders()
	var/obj/O = pick(spidermarks)
	new /obj/critter/killertomato/fox_on_bike/spider(O.loc)

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

	mouse
		density = 0
		layer = 2
		name = "cockmouse"
		icon_state = "mouse"

		Crossed()
			for(var/mob/M in range(src, 5))
				M << 'mousesqueek.ogg'

		angry
			icon_state = "angry_mouse"

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

	metroid
		name = "killer metroido"
		icon_state = "metroid"

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

/obj/spider_mark

	New()
		..()
		spidermarks += src

/obj/critter/killertomato/fox_on_bike/spider
	name = "spider"
	icon_state = "spider"

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