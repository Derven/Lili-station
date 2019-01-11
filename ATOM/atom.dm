/atom/var
	ZLevel = 1
	Climbing
	massweight = 0 //some physics

/proc/convert2energy(var/M)
	var/E = M*(SPEED_OF_LIGHT_SQ)
	return E

/proc/modulus(var/M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

/atom/proc/assume_air(datum/gas_mixture/giver)
	del(giver)
	return 0

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null


/atom/proc/ex_act()
	for(var/mob/M in range(2, src))
		M.playsoundforme('Explosion2.ogg')
		if(rand(1, 100) < 100 - robustness)
			if(!istype(src, /mob))
				del(src)
			else
				if(istype(src, /mob/simulated))
					var/mob/simulated/S = src
					S.death()
					del(src)

/atom/movable
	layer = 3
	var/flags
	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throw_hyuowing = 0
	var/throw_hyuow_speed = 2
	var/throw_hyuow_range = 7
	var/moved_recently = 0

/atom/movable/var/list/pullers = list()

/atom/movable/Move()
	var/turf/T = loc
	if(T)
		if(istype(T, /turf))
			layer = initial(layer) + (15 * (T.Height - 1))
	if(!anchored)
		..()
		for(var/mob/simulated/M in pullers)
			M.update_pulling()
		. = ..()
		if(.)
			for(var/mob/simulated/M in pullers)
				M.update_pulling()

/atom/movable/overlay

/atom
	layer = 2
	var/level = 2
	var/last_bumped = 0
	var/pass_flags = 0

	bullet_act(var/obj/item/projectile/Proj)
		return 0

	///Chemistry.
	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.