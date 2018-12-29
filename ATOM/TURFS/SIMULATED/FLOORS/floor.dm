/turf/simulated/floor
	name = "floor"
	icon_state = "floor"
	luminosity = 0
	thermal_conductivity = 0.040
	heat_capacity = 10000
	intact = 0
	robustness = 25
	temperature = T20C - 23
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/obj/wet/WET = null

	ex_act()
		for(var/mob/M in range(2, src))
			M.playsoundforme('Explosion2.ogg')

			if(rand(1, 100) < 100 - robustness)
				ReplaceWithPlating()

			if(rand(1, 100) < rand(1,5))
				del(src)

	verb/fall()
		set src in range(1, usr)
		if(Height < usr.ZLevel)
			for(var/mob/M in range(5, src))
				M << "\red [usr] falls onto [src]"
			usr.Move(src)
			usr.ZLevel = Height
			usr.layer = initial(usr.layer)
			usr.pixel_z = 32 * (usr.ZLevel - 1)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			for(var/mob/M in range(5, src.loc))
				M.playsoundforme('Crowbar.ogg')
				for(var/obj/structure/disposalpipe/DP in src)
					DP.invisibility = 0
			ReplaceWithPlating()
			new /obj/item/stack/tile(src)


		if(istype(W, /obj/item/weapon/mop))
			var/obj/item/weapon/mop/M = W
			if(M.watered > 0)
				M.watered -= 1
				for(var/obj/blood/B in src)
					del(B)
				WET = new(src)

	cool
		temperature = T20C - 35

/turf/proc/ReplaceWithPlating()
	var/prior_icon = icon_old
	var/old_dir = dir

	var/turf/simulated/floor/plating/W = new /turf/simulated/floor/plating(src)

	W.dir = old_dir
	if(prior_icon) W.icon_state = prior_icon
	else W.icon_state = "plating"
	W.opacity = 0

	if(W && W.air)
		var/new_ox = 0
		var/new_n2 = 0
		var/new_co2 = 0
		var/new_tx = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if(istype(T))
				var/datum/gas_mixture/G = T.return_air()
				new_ox += G.oxygen
				new_n2 += G.nitrogen
				new_co2 += G.carbon_dioxide
				new_tx += G.toxins

		W.air.nitrogen = new_n2/4
		W.air.oxygen = new_ox/4
		W.air.carbon_dioxide = new_co2/4
		W.air.toxins = new_tx/4
		W.air.update_values()

	air_master.tiles_to_update |= W

	var/turf/simulated/north = get_step(W,NORTH)
	var/turf/simulated/south = get_step(W,SOUTH)
	var/turf/simulated/east = get_step(W,EAST)
	var/turf/simulated/west = get_step(W,WEST)

	if(istype(north)) air_master.tiles_to_update |= north
	if(istype(south)) air_master.tiles_to_update |= south
	if(istype(east)) air_master.tiles_to_update |= east
	if(istype(west)) air_master.tiles_to_update |= west
	return W

/turf/proc/ReplaceWithSpace()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	air_master.tiles_to_update |= S

	var/turf/simulated/north = get_step(S,NORTH)
	var/turf/simulated/south = get_step(S,SOUTH)
	var/turf/simulated/east = get_step(S,EAST)
	var/turf/simulated/west = get_step(S,WEST)

	if(istype(north)) air_master.tiles_to_update |= north
	if(istype(south)) air_master.tiles_to_update |= south
	if(istype(east)) air_master.tiles_to_update |= east
	if(istype(west)) air_master.tiles_to_update |= west
	return S