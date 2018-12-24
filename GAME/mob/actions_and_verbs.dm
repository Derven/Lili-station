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

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if(nodamage) return

		if(exposed_temperature > bodytemperature)
			var/discomfort = min( abs(exposed_temperature - 310)/2000, 1.0)
			//adjustFireLoss(2.5*discomfort)
			//adjustFireLoss(5.0*discomfort)
			rand_burn_damage(20.0*discomfort, 20.0*discomfort)

		else
			var/discomfort = min( abs(exposed_temperature - 310)/2000, 1.0)
			//adjustFireLoss(2.5*discomfort)
			rand_burn_damage(20.0*discomfort, 20.0*discomfort)

	proc/handle_temperature(var/datum/gas_mixture/environment)
		if(cloth == null || cloth.space_suit == 0)
			if(H)
				H.clear_overlay()
				H.temppixels(round(bodytemperature))
				H.oxypixels(round(100 - oxyloss))
				H.healthpixels(round(health))
			var/environment_heat_capacity = environment.heat_capacity()
			var/transfer_coefficient = 1
			var/areatemp = environment.temperature
			if(abs(areatemp - bodytemperature) > 50)
				var/diff = areatemp - bodytemperature
				diff = diff / 5
				//world << "changed from [bodytemperature] by [diff] to [bodytemperature + diff]"
				bodytemperature += diff
			if(bodytemperature < 310)
				bodytemperature += rand(1, 2)
				if(bodytemperature < 170)
					heart.activate_stimulators(/datum/heart_stimulators/hard_sedative)

			handle_temperature_damage(chest, environment.temperature, environment_heat_capacity*transfer_coefficient)


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

mob/proc/dream()
	dreaming = 1
	var/list/dreams = list(
		"an ID card","a bottle","a familiar face","a crewmember","a toolbox","a security officer","the captain",
		"voices from all around","deep space","a doctor","the engine","a traitor","an ally","darkness",
		"light","a scientist","a monkey","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
		"a hat","the Lili","a ruined station","a planet","plasma","air","the medical bay","the bridge","blinking lights",
		"a blue light","an abandoned laboratory","Nanotrasen","The Syndicate","blood","healing","power","respect",
		"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying"
		)
	for(var/i = rand(1,4),i > 0, i--)
		var/dream_image = pick(dreams)
		dreams -= dream_image
		src << "\blue <i>... [dream_image] ...</i>"
		sleep(rand(20,50))
		if(sleeping <= 0)
			dreaming = 0
	dreaming = 0

/mob/var/dreaming = 0
/mob/var/paralysis = 0.0
/mob/var/stunned = 0.0
/mob/var/weakened = 0.0
/mob/var/sleeping = 0

/mob/proc/sleeping()
	sleeping = 1
	BL.invisibility = 0
	SB.icon_state = "sleep2"
	if(!lying)
		resting()

/mob/proc/awake()
	sleeping = 0
	BL.invisibility = 101
	SB.icon_state = "sleep1"
	if(lying)
		resting()

/mob/verb/sleepy()
	set name = "sleep"
	set category = "IC"
	sleeping()

/mob/verb/awakeme()
	set name = "awake"
	set category = "IC"
	awake()

/mob/proc/parstunweak()
	if (sleeping || stunned || weakened) //Stunned etc.
		if (stunned > 0)
			stunned--
			if(heart.pumppower < 145 && !lying)
				resting()
		if (stunned <= 0 && lying)
			resting()
		if (weakened > 0)
			weakened--
			if(!lying)
				resting()
		if (sleeping == 1)
			lying = 1
			if(prob(2) && !dreaming)
				dream()
			drop_item_v()
			swap_hand()
			drop_item_v()

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
	for(var/obj/machinery/radio/intercom/I in range(7, src))
		tell_me_more(name, fix255(msg))
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