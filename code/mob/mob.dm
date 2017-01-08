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