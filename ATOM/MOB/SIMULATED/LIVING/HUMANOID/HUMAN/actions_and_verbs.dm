/mob
	var/doing_this = 0
	verb/run_intent()
		usr.client.switch_rintent()


/mob/proc/do_after(var/time)
	if(doing_this == 0)
		var/turf/oldloc = usr.loc
		doing_this = 1
		var/image/timeicon = image('screen1.dmi',icon_state = "time")
		overlays.Add(timeicon)
		while(time)
			if(doing_this == 1)
				sleep(1)
				time--
				if(usr.loc != oldloc)
					doing_this = 0
					overlays.Remove(timeicon)
					return 0
			else
				doing_this = 0
				overlays.Remove(timeicon)
				return 0
		doing_this = 0
		overlays.Remove(timeicon)
		return 1

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

/mob/verb/Say(msg as text)
	set name = "Say"
	set category = "IC"
	if(!findtext(msg," ",1,2) && msg)
		overlays.Add(overlay_cur)
		for(var/mob/M in range(5, src))
			if(death == 0)
				M << "[src] says, \"[fix255(msg)]\""
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
		usr << "players in game: "
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

	else if (W == back)
		back = null
		overlays -= BP.backoverlay

	else if (W == id)
		id = null

/atom/movable/verb/pull()
	set name = "Pull"
	set src in oview(1)
	set category = "Local"
	var/mob/simulated/S = usr
	if(istype(S, /mob/simulated))
		if(S.pulling == src)
			S.stop_pulling()
			return
		if(S.pulling)
			S.stop_pulling()
		S.pullers += usr
		S.pulling = src
		S.PULL.icon_state = "pull_2"
		S.update_pulling()

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