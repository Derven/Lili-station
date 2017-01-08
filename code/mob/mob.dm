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