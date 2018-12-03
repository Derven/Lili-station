/atom/var
	ZLevel = 1
	Climbing

/atom/proc/ex_act()
	for(var/mob/M in range(2, src))
		M << 'Explosion2.ogg'
		if(rand(1, 100) < 100 - robustness)
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
		for(var/mob/M in pullers)
			M.update_pulling()
		. = ..()
		if(.)
			for(var/mob/M in pullers)
				M.update_pulling()

/atom/movable/overlay

/atom
	layer = 2
	var/level = 2
	var/last_bumped = 0
	var/pass_flags = 0

	///Chemistry.
	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	proc/assume_air(datum/air_group/giver)
		del(giver)
		return null

	proc/remove_air(amount)
		return null

	proc/return_air()
		if(loc)
			return loc.return_air()
		else
			return null