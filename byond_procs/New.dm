obj
	effect/hotspot
		New()
			..()
			dir = pick(SOUTH, NORTH, WEST, EAST, NORTHEAST, NORTHWEST, SOUTHWEST, SOUTHEAST)
			//sd_SetLuminosity(3)


/turf
	simulated
		New()
			..()

			if(istype(src, /turf/simulated/floor/plating))
				var/turf/simulated/floor/plating/P = src
				P.merge()

			if(!blocks_air)
				air = new

				air.oxygen = oxygen
				air.carbon_dioxide = carbon_dioxide
				air.nitrogen = nitrogen
				air.toxins = toxins

				air.temperature = temperature

				if(air_master)
					air_master.tiles_to_update.Add(src)

					find_group()

//				air.parent = src //TODO DEBUG REMOVE

			else
				if(air_master)
					for(var/direction in cardinal)
						var/turf/simulated/floor/target = get_step(src,direction)
						if(istype(target))
							air_master.tiles_to_update.Add(target)

/obj/machinery/New()
	..()
	machines.Add(src)

/obj/structure/disposalpipe
	New()
		..()
		base_icon_state = icon_state
		return

/obj/item/weapon/gun/energy/laser/captain
	New()
		..()
		processing_objects.Add(src)

/obj/structure/table
	New()
		..()
		set_up()

/turf/simulated/wall/window
	New()
		..()
		merge()

/turf/simulated/wall
	New()
		..()
		hide_wall = image('walls.dmi', icon_state = "[src.icon_state]_hide", layer = 10, loc = src)
		hide_wall.override = 1
		merge()
		//relativewall_neighbours()
		if(!istype(src, /turf/simulated/wall/window))
			if(prob(30))
				var/rand_num = rand(1,2)
				overlays += image(icon = 'walls.dmi', icon_state = "overlay_[rand_num]")