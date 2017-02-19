/atom/movable/Move()
	if(!anchored)
		..()
		for(var/mob/M in pullers)
			M.update_pulling()
		. = ..()
		if(.)
			for(var/mob/M in pullers)
				M.update_pulling()

/mob
	Move()
		if(lying)
			return

		var/turf/wall_east = get_step(src, EAST)
		var/turf/wall_south = get_step(src, SOUTH)

		if(usr && usr.client)
			if(usr.client.dir == NORTH)
				if(dir == 2)
					wall_east = locate(usr.x + 1, usr.y - 1, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x + 1, usr.y, usr.z)

			if(usr.client.dir == EAST)
				if(dir == 2)
					wall_east = locate(usr.x - 1, usr.y - 1, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x - 1, usr.y, usr.z)

			if(usr.client.dir == SOUTH)
				if(dir == 2)
					wall_east = locate(usr.x - 1, usr.y, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x - 1, usr.y + 1, usr.z)

			if(usr.client.dir == WEST)
				if(dir == 2)
					wall_east = locate(usr.x + 1, usr.y, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x + 1, usr.y + 1, usr.z)

		for(var/turf/simulated/wall/W in range(2, src))
			W.clear_for_all()

		if(wall_east && istype(wall_east, /turf/simulated/wall))
			var/turf/simulated/wall/my_wall = wall_east
			my_wall.hide_me()

		if(wall_south && istype(wall_south, /turf/simulated/wall))
			var/turf/simulated/wall/my_wall = wall_south
			my_wall.hide_me()

		if(!istype(loc, /turf/simulated/floor/stairs))
			pixel_z = (ZLevel-1) * 32

		var/oldloc = src.loc
		..()

		if(src.pulling)
			if(!step_towards(src.pulling, src) && (get_dist(src.pulling, src) > 1))
				if(!step_towards(src.pulling, oldloc))
					update_pulling()