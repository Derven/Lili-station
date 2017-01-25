/proc/get_turf(turf/location as turf)
	while (location)
		if (istype(location, /turf))
			return location

		location = location.loc
	return null

/proc/do_after(mob/M as mob, time as num)
	var/turf/T = M.loc
	//var/holding = M.equipped()
	for(var/i=0, i<time)
		if(M)
			if (M.loc == T)
				i++
				sleep(1)
			else
				return 0
	return 1


/proc/between(var/low, var/middle, var/high)
	return max(min(middle, high), low)

/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

/proc/onclose(mob/user, windowid, var/atom/ref=null)
	if(!user.client) return
	var/param = "null"
	if(ref)
		param = "\ref[ref]"

	winset(user, windowid, "on-close=\".windowclose [param]\"")

/proc/get_area_name(N) //get area by it's name
	for(var/area/A in world)
		if(A.name == N)
			return A
	return 0

/atom/proc/message_to(var/rang, var/msg)
	for(var/mob/M in range(rang, src))
		M << msg