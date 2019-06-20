// /atom/movable vars
//---------------------
/atom/movable/var/flags
/atom/movable/var/last_move = null
/atom/movable/var/anchored = 0
/atom/movable/var/move_speed = 10
/atom/movable/var/l_move_time = 1
/atom/movable/var/m_flag = 1
/atom/movable/var/throw_hyuowing = 0
/atom/movable/var/throw_hyuow_speed = 2
/atom/movable/var/throw_hyuow_range = 7
/atom/movable/var/moved_recently = 0
/atom/movable/var/list/pullers = list()
/atom/movable/overlay
/atom/movable/layer = 3
//---------------------

// /atom/movable procs
//---------------------
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

/atom/movable/Bump(var/atom/A as mob|obj|turf)
	spawn( 0 )
		if ((A))
			A.Bumped(src)
		return
	..()
	return

/atom/movable/verb/pull()
	set name = "Pull"
	set src in oview(1)
	set category = "Local"
	var/mob/simulated/S = usr
	if(istype(S, /mob/simulated/))
		if(S.pulling == src)
			S.stop_pulling()
			return
		if(S.pulling)
			S.stop_pulling()
		if(istype(src, /mob))
			var/mob/M = src
			M.mypool = 1
		S.pullers += usr
		S.pulling = src
		S.PULL.icon_state = "pull_2"
		S.update_pulling()

/atom/movable/proc/throw_hyuow_at(var/mob/M, atom/target, range, speed)
	if(!target)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throw_hyuowing = 1

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y
		while(((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throw_hyuowing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw_hyuow range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
	else
		var/error = dist_y/2 - dist_x
		while(src && target &&((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throw_hyuowing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw_hyuow range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
	var/area/A
	if(istype(M.loc, /turf))
		A = M.loc.loc
	if((istype(src.loc, /turf/space)) || (A.has_gravity == 0))
		M.inertia_dir = get_dir(target, M)
		step(M, M.inertia_dir)

	//done throw_hyuowing, either because it hit something or it finished moving
	src.throw_hyuowing = 0

/atom/movable/proc/myspaceisperfect()
	var/area/A
	if(istype(src.loc, /turf))
		A = src.loc.loc
		if(istype(src.loc, /turf/space) || A.has_gravity == 0)
			var/pixel_j_min = 0
			var/pixel_j_max = 6
			var/oldpixel_j = 0
			if(oldpixel_j == 0)
				pixel_z = rand(pixel_j_min, pixel_j_max)
				var/newpixel_j = rand(pixel_j_min, pixel_j_max)
				if(abs(oldpixel_j - newpixel_j) <= 2 && abs(oldpixel_j - newpixel_j) > 0)
					pixel_z = newpixel_j
		else
			if(istype(src, /mob/simulated/living/humanoid))
				if(src:onstructure == 0)
					pixel_z = initial(pixel_z)

/atom/movable/proc/check_max()
	if(x == 255)
		x = 2
		if(z == 1 || z == 4)
			if(z == 4)
				if(prob(25))
					z = 1
				else
					z = 3
			else
				z = 3
		else
			z += 1
		for(var/mob/M in range(3, src))
			M << "\blue Hyperdrive activated"
	if(y == 255)
		y = 2
		if(z == 1 || z == 4)
			if(z == 4)
				if(prob(25))
					z = 1
				else
					z = 3
			else
				z = 3
		else
			z += 1
		for(var/mob/M in range(3, src))
			M << "\blue Hyperdrive activated"
	if(y == 1)
		y = 254
		if(z == 1 || z == 4)
			if(z == 4)
				if(prob(25))
					z = 1
				else
					z = 3
			else
				z = 3
		else
			z += 1
		for(var/mob/M in range(3, src))
			M << "\blue Hyperdrive activated"
	if(x == 1)
		x = 254
		if(z == 1 || z == 4)
			if(z == 4)
				if(prob(25))
					z = 1
				else
					z = 3
			else
				z = 3
		else
			z += 1
		for(var/mob/M in range(3, src))
			M << "\blue Hyperdrive activated"