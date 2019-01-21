/obj/machinery/airlock
	name = "airlock"
	icon = 'airlock.dmi'
	icon_state = "close"
	power_channel = ENVIRON
	var/datum/idchecker/ID
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 1
	opacity = 1
	anchored = 1
	switcher = 1
	var/list/ids = list(/datum/id/captain, /datum/id/security, /datum/id/doctor, /datum/id/assistant)

	load = 25
	var
		close = 1

	proc/update_nearby_tiles()
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/north = get_step(source,NORTH)
		var/turf/simulated/south = get_step(source,SOUTH)
		var/turf/simulated/east = get_step(source,EAST)
		var/turf/simulated/west = get_step(source,WEST)

		if(istype(source)) air_master.tiles_to_update += source
		if(istype(north)) air_master.tiles_to_update += north
		if(istype(south)) air_master.tiles_to_update += south
		if(istype(east)) air_master.tiles_to_update += east
		if(istype(west)) air_master.tiles_to_update += west

		return 1

	New()
		..()
		var/turf/simulated/floor/T = src.loc
		ID = add_idchecker(src, ids)
		T.blocks_air = 1

	attack_hand(mob/simulated/living/humanoid/user)
		if(istype(user, /mob/simulated/living/humanoid))
			if(charge == 0)
				return
			else
				if(user.id && ID.check_id(user.id))
					if(close)
						open()
					else
						close()
					..()

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			if(!charge)
				var/turf/simulated/floor/T = src.loc
				for(var/mob/M in range(5, src))
					M.playsoundforme('airlock.ogg')
				if(close)
					flick("open_state",src)
					icon_state = "open"
					close = 0
					density = 0
					opacity = 0
					if(istype(loc, /turf/simulated))
						sd_SetOpacity(0)
						T.blocks_air = 0
						update_nearby_tiles()
				else
					close = 1
					sd_SetOpacity(1)
					T.blocks_air = 1
					update_nearby_tiles()
					update_nearby_tiles()
					density = 1
					opacity = 1
					flick("close_state",src)
					icon_state = "close"
				..()

	proc/open()
		if(!close)
			return
		for(var/mob/MB in range(5, src))
			MB.playsoundforme('airlock.ogg')
		flick("open_state",src)
		icon_state = "open"
		close = 0
		density = 0
		if(!istype(src, /obj/machinery/airlock/glassairlock))
			opacity = 0
		if(istype(loc, /turf/simulated))
			var/turf/simulated/floor/T = get_turf(src)
			sd_SetOpacity(0)
			T.blocks_air = 0
			update_nearby_tiles()
		spawn(150)
			close()

	proc/close()
		if(close)
			return

		for(var/mob/simulated/living/humanoid/M in get_turf(src))
			if(M.density && M != src)
				spawn(60)
					close()
				return
		for(var/mob/MB in range(5, src))
			MB.playsoundforme('airlock.ogg')
		close = 1
		if(istype(loc, /turf/simulated))
			var/turf/simulated/floor/T = get_turf(src)
			sd_SetOpacity(1)
			T.blocks_air = 1
			update_nearby_tiles()
		density = 1
		if(!istype(src, /obj/machinery/airlock/glassairlock))
			opacity = 1
		flick("close_state",src)
		icon_state = "close"

	green
		icon = 'airlock_green.dmi'

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