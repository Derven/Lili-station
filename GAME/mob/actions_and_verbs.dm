/mob
	verb/run_intent()
		usr.client.switch_rintent()

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
				W.layer = initial(W.layer) + (15 * (ZLevel - 1))
				W.pixel_z = 32 * (ZLevel - 1)
		var/turf/T = get_turf(loc)
		if (istype(T))
			T.Entered(W)
	return

/mob

	proc/swap_hand()
		src.hand = !( src.hand )
		if(hand)
			LH.icon_state = "l_hand_a"
			RH.icon_state = "r_hand"
		else
			RH.icon_state = "r_hand_a"
			LH.icon_state = "l_hand"

	verb/suicide()
		set name = "Suicide"
		set category = "IC"
		if(density == 1)
			death()
		else
			src << "no"

	proc/stop_pulling()
		pulling.pullers -= src
		pulling = null
		PULL.icon_state = "pull_1"

	proc/update_pulling()
		if((get_dist(src, pulling) > 1) || !isturf(pulling.loc))
			stop_pulling()

	proc/handle_temperature(var/mytemp)
		if(cloth == null || cloth.space_suit == 0)
			H.clear_overlay()
			H.temppixels(mytemp)
			H.oxypixels(H.cur_onum)
			H.healthpixels(H.cur_hnum)

			if(mytemp > 373)
				var/datum/organ/external/affecting = get_organ("chest")
				apply_damage(round(mytemp/10), BURN, affecting, 0)
				affecting = get_organ("head")
				apply_damage(round(mytemp/10), BURN, affecting, 0)
				src << select_lang("\red Вы чувствуете тепло", "\red You feel the heat!")

			if(mytemp < 273)
				var/datum/organ/external/affecting = get_organ("chest")
				apply_damage(round((mytemp/10) * 3), BURN, affecting, 0)
				affecting = get_organ("head")
				apply_damage(round((mytemp/10) * 3), BURN, affecting, 0)
				src << select_lang("\red Вы чувствуете холод", "\red You feel the freeze!")

			if(istype(src.loc, /turf/space))
				var/datum/organ/external/affecting = get_organ("chest")
				mytemp = 300
				apply_damage(round((mytemp/10) * 3), BURN, affecting, 0)
				affecting = get_organ("head")
				apply_damage(round((mytemp/10) * 3), BURN, affecting, 0)
				src << select_lang("\red Вы чувствуете холод", "\red You feel the freeze!")


/mob/proc/resting()
	if(!lying)
		src.transform = turn(src.transform, 90)
		lying = 1
		density = 0
		return
	else
		if(death == 0 && reagents.has_reagent("blood", 80))
			src.transform = turn(src.transform, -90)
			density = 1
			lying = 0
			return

/mob/verb/rest()
	set name = "Rest"
	set category = "IC"
	resting()

/mob/verb/miracle()
	set name = "Miracle"
	set category = "IC"
	death = 0
	reagents.add_reagent("blood", 200)
	heal_brute(80)

/mob/proc/drop_item_v()
	if (stat == 0)
		drop_item()
	return

/mob/verb/Say(msg as text)
	set name = "Say"
	set category = "IC"
	if(!findtext(msg," ",1,2) && msg)
		overlays.Add(overlay_cur)
		for(var/mob/M in range(5, src))
			if(death == 0)
				M << M.select_lang("[src] говорит, \"[fix255(msg)]\"", "[src] says, \"[fix255(msg)]\"")
		sleep(8)
		overlays.Remove(overlay_cur)
	//for(var/obj/machinery/radio/intercom/I in range(7, src))
	//	tell_me_more(name, fix255(msg))
	return fix255(msg)

/mob/verb/Emote(msg as text)
	set name = "Emote"
	set category = "IC"
	for(var/mob/M in range(5, src))
		if(msg)
			if(!findtext(msg," ",1,2))
				M << "<b>[src] [fix255(msg)]</b>"

/mob/verb/OOC(msg as text)
	set name = "OOC"
	set category = "OOC"
	if(msg)
		if(!findtext(msg," ",1,2))
			world << "\blue OOC [usr.ckey]: [fix255(msg)]"

/mob
	var
		screen_res = "1920x1080"

	verb/respawn()
		if(istype(src, /mob/ghost))
			var/mob/M = new()
			M.key = key

	verb/who()
		set name = "Who"
		set category = "OOC"
		usr << usr.select_lang("игроки в игре: ", "players in game: ")
		for(var/mob/M in world)
			if(M.client)
				usr << M.ckey

	proc/view_to_res()
		if(usr.client)
			switch(screen_res)
				if("640x480")
					usr.client.view = 4
				if("800x600")
					usr.client.view = 5
				if("1024x768")
					usr.client.view = 6
				if("1280x1024")
					usr.client.view = 7
				if("1920x1080")
					usr.client.view = 8

/mob/proc/u_equip(obj/item/W as obj)
	if (W == r_hand)
		r_hand = null

	else if (W == l_hand)
		l_hand = null

	else if (W == cloth)
		cloth = null

/atom/movable/verb/pull()
	set name = "Pull"
	set src in oview(1)
	set category = "Local"
	if(usr.pulling == src)
		usr.stop_pulling()
		return
	if(usr.pulling)
		usr.stop_pulling()
	src.pullers += usr
	usr.pulling = src
	usr.PULL.icon_state = "pull_2"
	usr.update_pulling()

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

///BUILD/CRAFT SYSTEM
/mob
	var/atom/mycraft_atom
	var/image/mycraft

/mob/proc/show(var/atom/mybuild)
	if(mycraft)
		client.screen.Remove(mycraft)
	mycraft = image(icon = mybuild.icon, icon_state = mybuild.icon_state, layer = 15)
	mycraft_atom = mybuild

///BUILD/CRAFT SYSTEM