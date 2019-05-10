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

/obj/plant
	icon = 'jungles.dmi'
	var/power = 0
	var/stage = 0
	var/health = 100

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
		if(power > 45 && stage == 0)
			stage = 1
			for(var/turf/simulated/S in range(1,src))
				if(prob(25))
					plant_me(S)
			power = 0
		if(power > 85 && stage == 1)
			stage = 2
			for(var/turf/simulated/S in range(2,src))
				if(prob(45))
					plant_me(S)
			power = 0
		check_turf()

	process()
		power += 1
		check_power()
		if(icon_state == "jungle_ns" || icon_state == "jungle_we")
			if(power > 25)
				for(var/turf/simulated/S in range(1,src))
					if(prob(15))
						plant_me(S)
				power = 0
