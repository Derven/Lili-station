obj
	effect/hotspot
		Del()
			if (istype(loc, /turf/simulated))
				var/turf/simulated/T = loc
				loc:active_hotspot = null
				//src.sd_SetLuminosity(0)



				if(T.to_be_destroyed)
					var/chance_of_deletion
					if (T.heat_capacity) //beware of division by zero
						chance_of_deletion = T.max_fire_temperature_sustained / T.heat_capacity * 8 //there is no problem with prob(23456), min() was redundant --rastaf0
					else
						chance_of_deletion = 100
					if(prob(chance_of_deletion))
						T.ReplaceWithSpace()
					else
						T.to_be_destroyed = 0
						T.max_fire_temperature_sustained = 0

				loc = null

			..()

/turf
	simulated
		Del()
			if(air_master)
				if(parent)
					air_master.groups_to_rebuild.Add(parent)
					parent.members.Remove(src)
				else
					air_master.active_singletons.Remove(src)
			if(active_hotspot)
				del(active_hotspot)
			if(blocks_air)
				for(var/direction in list(NORTH, SOUTH, EAST, WEST))
					var/turf/simulated/tile = get_step(src,direction)
					if(istype(tile) && !tile.blocks_air)
						air_master.tiles_to_update.Add(tile)
			..()

/obj/structure/disposalpipe
	Del()
		var/obj/structure/disposalholder/H = locate() in src
		if(H)
			// holder was present
			H.active = 0
			var/turf/T = src.loc
			if(T.density)
				// deleting pipe is inside a dense turf (wall)
				// this is unlikely, but just dump out everything into the turf in case

				for(var/atom/movable/AM in H)
					AM.loc = T
					AM.pipe_eject(0)
				del(H)
				..()
				return

			// otherwise, do normal expel from turf
			expel(H, T, 0)
		..()

/obj/machinery/Del()
	machines.Remove(src)
	..()

/obj/item/weapon/gun/energy/laser/captain
	Del()
		processing_objects.Remove(src)
		..()

/obj/structure/table
	Del()
		..()
		set_up()

/turf/simulated/wall/window
	Del()
		..()
		for(var/atom/movable/AM in src)
			AM.ZLevel -= 1
			pixel_z = (ZLevel - 1) * 32