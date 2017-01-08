/mob
	icon = 'mob.dmi'
	icon_state = "mob"

	proc/update_pulling()
		if (!pulling)
			PULL.icon_state = "pull_1"
			return 0
		else
			PULL.icon_state = "pull_2"

	Move()
		..()
		if(src.pulling)
			step(src.pulling, get_dir(src.pulling.loc, usr))

/atom/proc/relaymove()
	return

/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera)
		return
	spawn(1)
		var/oldeye=M.client.eye
		var/x
		M.shakecamera = 1
		for(x=0; x<duration, x++)
			M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		M.shakecamera = 0
		M.client.eye=oldeye

/mob/proc/u_equip(obj/item/W as obj)
	if (W == r_hand)
		r_hand = null
	else if (W == l_hand)
		l_hand = null

/atom/movable/verb/pull()
	set name = "Pull"
	set src in oview(1)
	set category = "Local"

	if(usr.pulling != src)
		if (!( usr ))
			return

		if(src.loc == usr)
			return

		if (!( src.anchored ))
			usr.pulling = src
			//Wire: Hi this was so dumb. Turns out it isn't only humans that have huds, who woulda thunk!!
			if (usr && usr.PULL) //yes this uses the dreaded ":", deal with it
				usr.update_pulling()
		return
	else
		usr.pulling = null
		usr.update_pulling()
		return

/atom/movable/proc/throw_hyuow_at(atom/target, range, speed)
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

	//done throw_hyuowing, either because it hit something or it finished moving
	src.throw_hyuowing = 0
