/obj/machinery/airlock
	name = "airlock"
	icon = 'airlock.dmi'
	icon_state = "close"
	power_channel = ENVIRON
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 1
	opacity = 1
	anchored = 1
	switcher = 1

	load = 25
	var
		close = 1

	New()
		..()
		var/turf/simulated/floor/T = src.loc
		T.blocks_air = 1
		T.update_air_properties()

	attack_hand(mob/user)
		var/turf/simulated/floor/T = src.loc
		if(charge == 0)
			return
		else
			for(var/mob/M in range(5, src))
				M << 'airlock.ogg'
			if(close == 1)
				flick("open_state",src)
				icon_state = "open"
				close = 0
				density = 0
				opacity = 0
				T.blocks_air = 0
			else
				close = 1
				T.blocks_air = 1
				density = 1
				opacity = 1
				flick("close_state",src)
				icon_state = "close"

		if(!T.blocks_air)
			T.air = new

			T.air.oxygen = T.oxygen
			T.air.carbon_dioxide = T.carbon_dioxide
			T.air.nitrogen = T.nitrogen
			T.air.toxins = T.toxins

			T.air.temperature = T.temperature

			if(air_master)
				air_master.tiles_to_update.Add(src)

				T.find_group()
		else
			if(air_master)
				if(T.parent)
					air_master.groups_to_rebuild.Add(T.parent)
					T.parent.members.Remove(src)
				else
					air_master.active_singletons.Remove(src)
			if(T.active_hotspot)
				del(T.active_hotspot)
			if(T.blocks_air)
				for(var/direction in list(NORTH, SOUTH, EAST, WEST))
					var/turf/simulated/tile = get_step(src,direction)
					if(istype(tile) && !tile.blocks_air)
						air_master.tiles_to_update.Add(tile)
			..()

/obj/machinery/airlock/firedor
	name = "firedoor"
	icon = 'firedoor.dmi'
	icon_state = "open"
	power_channel = ENVIRON
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 0
	opacity = 0
	anchored = 1
	switcher = 1

	load = 25
	close = 0
	var/alert = 0

	New()
		icon_state = "open"
		..()

	process()
		var/turf/simulated/floor/T = src.loc
		var/datum/gas_mixture/GM = T.return_air()
		if(GM.oxygen < 21)
			if(alert == 0)
				alert = 1
				close = 1
				T.blocks_air = 1
				density = 1
				opacity = 1
				flick("close_state",src)
				icon_state = "close"

		if(!T.blocks_air)
			T.air = new

			T.air.oxygen = T.oxygen
			T.air.carbon_dioxide = T.carbon_dioxide
			T.air.nitrogen = T.nitrogen
			T.air.toxins = T.toxins

			T.air.temperature = T.temperature

			if(air_master)
				air_master.tiles_to_update.Add(src)

				T.find_group()
		else
			if(air_master)
				if(T.parent)
					air_master.groups_to_rebuild.Add(T.parent)
					T.parent.members.Remove(src)
				else
					air_master.active_singletons.Remove(src)
			if(T.active_hotspot)
				del(T.active_hotspot)
			if(T.blocks_air)
				for(var/direction in list(NORTH, SOUTH, EAST, WEST))
					var/turf/simulated/tile = get_step(src,direction)
					if(istype(tile) && !tile.blocks_air)
						air_master.tiles_to_update.Add(tile)