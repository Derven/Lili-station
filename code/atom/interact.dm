atom/proc/attack_hand()

/obj/item/proc/afterattack(var/atom/movable/M, var/mob/user)
	if(istype(M, /mob))
		M:attacked_by(src, user, parse_zone(user.ZN_SEL.selecting))
	return

/proc/get_edge_target_turf(var/atom/A, var/direction)

	var/turf/target = locate(A.x, A.y, A.z)
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target


/atom/Click()
	var/obj/item/I = usr.get_active_hand()
	if(istype(I, /obj/item/weapon/gun))
		I.afterattack(src)
	if(src in range(1, usr))
		if(!usr.get_active_hand())
			attack_hand(usr)
		else
			if(src == usr.get_active_hand())
				attack_self()
			else
				attackby(usr.get_active_hand())
				if(I)
					I.afterattack(src, usr)



/atom/proc/attack_self()
	return

/mob/proc/get_active_hand()
	if (hand)
		return l_hand
	else
		return r_hand

/mob/proc/get_inactive_hand()
	if ( ! hand)
		return l_hand
	else
		return r_hand

/obj/item/proc/pickup(mob/user)
	return

/mob/proc/put_in_hand(var/obj/item/I)
	if(!I) return
	I.loc = src
	if (hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/mob/proc/put_in_inactive_hand(var/obj/item/I)
	I.loc = src
	if (!hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/obj/item/attack_hand(mob/user as mob)

	src.loc = user
	src.layer = 20

	if (user.hand)
		user.l_hand = src
		user.LH.update_slot(src)
	else
		user.r_hand = src
		user.RH.update_slot(src)

	src.pickup(user)

/obj/item/proc/dropped(mob/user as mob)
	..()

/mob/proc/equipped()
	if (hand)
		return l_hand
	else
		return r_hand
	return

/mob/proc/drop_item(var/atom/target)
	var/obj/item/W = equipped()

	if (W)
		if (client)
			client.screen -= W
		if (W)
			if(target)
				W.loc = target.loc
			else
				W.loc = loc
			W.dropped(src)
			u_equip(W)
			if (W)
				W.layer = initial(W.layer)
		var/turf/T = get_turf(loc)
		if (istype(T))
			T.Entered(W)
	return

/mob/proc/drop_item_v()
	if (stat == 0)
		drop_item()
	return

/mob/proc/swap_hand()
	src.hand = !( src.hand )
	if(hand)
		LH.icon_state = "l_hand_a"
		RH.icon_state = "r_hand"
	else
		RH.icon_state = "r_hand_a"
		LH.icon_state = "l_hand"

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
	return 0

/atom/movable/Bump(var/atom/A as mob|obj|turf)
	spawn( 0 )
		if ((A))
			A.Bumped(src)
		return
	..()
	return

/obj/Bumped(atom/movable/MV)
	if(density == 1)
		if(istype(MV, /mob))
			var/mob/user = MV
			if(!anchored)
				step(src, user.dir)
				user.pulling = 0
				user.update_pulling()
		else
			if(!anchored)
				step(src, MV.dir)