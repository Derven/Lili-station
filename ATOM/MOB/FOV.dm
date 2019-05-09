var/list/mobs_for_fov = list()

/mob
	var/list/image/fov_images = list()

/mob/proc/calculate_fov()
	..()
	for(var/mob/M in mobs_for_fov)
		if(M)
			if(check_fov_dir(M) == 1)
				var/image/I = image(M.icon,M,M.icon_state)
				I.alpha = round(255/100 * (100 / get_dist(M, src)) )
				I.override = 1
				fov_images.Add(I)
		if(M.client && M in oview())
			spawn(4)
				M.process_fov()

mob/proc/check_fov_dir(var/mob/M)
	if(dir == SOUTH)
		if(M.y > y)
			return 1
		else
			return 0

	if(dir == NORTH)
		if(M.y < y)
			return 1
		else
			return 0

	if(dir == WEST)
		if(M.x > x)
			return 1
		else
			return 0

	if(dir == EAST)
		if(M.x < x)
			return 1
		else
			return 0

mob/proc/del_fov()
	..()
	for(var/image/I in fov_images)
		del(I)

mob/proc/see_you()
	..()
	for(var/image/I in fov_images)
		usr << I

/mob/proc/process_fov()
	if(client)
		del_fov()
		calculate_fov()
		see_you()