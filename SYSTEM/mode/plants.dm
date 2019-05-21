/obj/structure/grass_cutter
	icon = 'stationobjs.dmi'
	icon_state = "grass-cutter"
	name = "grass-cutter"
	var/on = 0
	density = 1

	New()
		..()
		create_reagents(150)
		reagents.add_reagent("diesel",100)

	examine()
		usr << "fuel level [reagents.get_reagent_amount("diesel")]"

	Move()
		..()
		if(on == 1)
			if(reagents.has_reagent("diesel", 5))
				for(var/obj/plant/P in range(1,src))
					del(P)
				reagents.remove_reagent("diesel",5)
			else
				for(var/mob/M in range(2,src))
					M << "The engine makes a noise and stalls"

	attack_hand()
		usr << "You turn [src] [on == 1 ? "off" : "on"]"
		if(on == 1)
			on = 0
		else
			on = 1

/mob/simulated/living/humanoid
	var/obj/plant/mushroom/human_mush/hm

/obj/plant/mushroom/human_mush/verb/infect_other()
	set src = usr.contents
	if(istype(usr, /mob/simulated/living/humanoid))
		if(usr:hm && usr:hm.stage == 2)
			for(var/mob/simulated/living/humanoid/H in range(3, usr))
				H.mush_infect()
			usr:hm.power -= 5

/obj/plant/mushroom/human_mush/verb/check_mush_power()
	set src = usr.contents
	if(istype(usr, /mob/simulated/living/humanoid))
		if(usr:hm && usr:hm.stage >= 1)
			usr << "\red Your mush power is [usr:hm.power]"


/mob/simulated/living/humanoid/proc/mush_infect()
	if(!hm)
		hm = new /obj/plant/mushroom/human_mush(src)

/mob/simulated/living/humanoid/proc/hinfect()
	set name = "infect"
	set category = null
	if(hm)
		hm.infect()

/obj/plant
	icon = 'jungles.dmi'
	anchored = 1
	var/power = 0
	var/stage = 0
	var/health = 100

	mushroom
		icon = 'mushrooms.dmi'
		health = 300

		proc/infect()
			if(prob(10))
				for(var/mob/simulated/living/humanoid/H in range(5,src))
					if(H.cloth)
						if(!H.cloth.space_suit == 1)
							H.mush_infect()
					else
						H.mush_infect()

				var/location = get_turf(src)
				var/datum/effect/effect/system/chem_smoke_spread/S = new /datum/effect/effect/system/chem_smoke_spread
				S.attach(location)
				S.set_up(reagents, 10, 0, location)
				spawn(0)
					S.start()
					sleep(10)
					S.start()
				reagents.clear_reagents()
				if(prob(15))
					for(var/mob/M in range(4,src))
						M << "\red PFFFFFF"

		plant_me(var/turf/T)
			for(var/obj/plant/mushroom/P in T)
				return
			new /obj/plant/mushroom(T)

		process()
			for(var/turf/simulated/floor/F in range(1,src))
				var/datum/gas_mixture/G = F.return_air()
				if(G.temperature < 170 || G.temperature > 600)
					del(src)

			if(stage >= 0 && stage < 2)
				if(power > 15)
					if(prob(50))
						infect()

			power += 1
			check_power()
			if(icon_state == "jungle_ns" || icon_state == "jungle_we")
				if(power > 15)
					for(var/turf/simulated/S in range(1,src))
						if(prob(15))
							plant_me(S)
					power = 0

		New()
			..()
			check_turf()
			create_reagents(100)
			START_PROCESSING(SSobj, src)

		human_mush
			var/image/overlay_stage_1
			var/image/overlay_stage_2

			check_turf()
				return

			New()
				..()
				START_PROCESSING(SSobj, src)

			process()
				if(istype(src.loc, /mob/simulated/living/humanoid))
					var/mob/simulated/living/humanoid/H = src.loc
					power += 1
					if(power > 5 && stage < 1)
						stage = 1
						if(H.gender == "male")
							overlay_stage_1 = image(icon = 'mushrooms.dmi', icon_state = "mob_infected", layer = 22)
						else
							overlay_stage_1 = image(icon = 'mushrooms.dmi', icon_state = "fem_infected", layer = 22)
						H.overlays += overlay_stage_1
					if(power > 135)
						H << "\blue <h1>You have become a perfect mushroom.</h1>"
						for(var/turf/simulated/S in range(2, H))
							new /obj/plant/mushroom(S)
						H.gib()
					switch(stage)
						if(1)
							if(power > 5)
								if(prob(25))
									infect()
							H.heal_brute(rand(3,5))
							H.heal_burn(rand(4,7))
							if(H.client)
								H.client.other_effects = 2
							if(power > 35)
								infect()
								stage = 2
								H.overlays -= overlay_stage_1
								if(H.gender == "male")
									overlay_stage_2 = image(icon = 'mushrooms.dmi', icon_state = "mob_infected_hard", layer = 22)
								else
									overlay_stage_2 = image(icon = 'mushrooms.dmi', icon_state = "fem_infected_hard", layer = 22)
								H.overlays += overlay_stage_2
								verbs += /mob/simulated/living/humanoid/proc/hinfect
						if(2)
							if(H.client)
								H.client.other_effects = 4
							H.heal_brute(rand(7,15))
							H.heal_burn(rand(10,20))
							if(H.heart)
								if(H.heart.brute_dam > 1)
									H.heart.brute_dam -= 1
								if(H.heart.burn_dam > 1)
									H.heart.burn_dam -= 1
							if(H.lungs.brute_dam > 1)
								H.lungs.brute_dam -= 1
							if(H.lungs.burn_dam > 1)
								H.lungs.burn_dam -= 1
							if(H.oxyloss > 1)
								H.oxyloss -= 1
							if(prob(5))
								H << "\red <h1>You need to infect others...</h1>"
							if(prob(3))
								new /obj/plant/mushroom(H.loc)


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/saw))
			del(src)
		else
			if(health > 0)
				health -= W.force
		if(health <= 0)
			del(src)

	Del()
		if(icon_state == "jungle_ns" || icon_state == "jungle_we")
			if(istype(src.loc, /turf/simulated/wall/newicon/window))
				src.loc.opacity = 0
		..()

	New()
		..()
		check_turf()
		START_PROCESSING(SSobj, src)

	proc/check_turf()
		if(istype(src.loc, /turf/simulated/wall))
			var/turf/simulated/wall/newicon/NI = src.loc
			if(istype(NI, /turf/simulated/wall/newicon/window))
				NI.opacity = 1
			if(findtext(NI.icon_state,"ns")==0)
				icon_state = "jungle_ns"
			if(findtext(NI.icon_state,"we")==0)
				icon_state = "jungle_we"
		else
			if(istype(src.loc, /turf/simulated/floor))
				check_stage()
			else
				del(src)

	proc/check_stage()
		switch(stage)
			if(0)
				icon_state = "jungle_small_floor"
			if(1)
				icon_state = "jungle_medium_floor"
				density = 1
			if(2)
				icon_state = "jungle_hard_floor"
				density = 1
				opacity = 1

	proc/plant_me(var/turf/T)
		for(var/obj/plant/P in T)
			return
		new /obj/plant(T)

	proc/check_power()
		if(power > 15 && stage == 0)
			stage = 1
			for(var/turf/simulated/S in range(1,src))
				if(prob(25))
					plant_me(S)
			power = 0
		if(power > 15 && stage == 1)
			stage = 2
			for(var/turf/simulated/S in range(2,src))
				if(prob(45))
					plant_me(S)
			power = 0
		check_turf()

	process()
		for(var/turf/simulated/floor/F in range(1,src))
			var/datum/gas_mixture/G = F.return_air()
			if(G.oxygen < 3)
				del(src)
				return
			if(G.temperature < 270 || G.temperature > 400)
				del(src)

		power += 1
		check_power()
		if(icon_state == "jungle_ns" || icon_state == "jungle_we")
			if(power > 15)
				for(var/turf/simulated/S in range(1,src))
					if(prob(15))
						plant_me(S)
				power = 0
