// mob vars
//---------------------
/mob/step_size = 64
/mob/layer = 18
/mob/density = 1
/mob/layer = 18.0
/mob/animate_movement = 2
/mob/flags = NOREACT
/mob/mouse_drag_pointer = MOUSE_ACTIVE_POINTER
/mob/icon = 'mob.dmi'
/mob/icon_state = "mob"
/mob/layer = 15

/mob/var/onstructure = 0
/mob/var/image/cig_overlay
/mob/var/atom/mycraft_atom
/mob/var/image/mycraft
/mob/var/screen_res = "1920x1080"
/mob/var/dreaming = 0
/mob/var/paralysis = 0.0
/mob/var/stunned = 0.0
/mob/var/weakened = 0.0
/mob/var/sleeping = 0
/mob/var/mypool = 0
/mob/var/doing_this = 0
/mob/var/bruteloss = 0.0//Living
/mob/var/fireloss = 0.0//Living
/mob/var/usrcolor
/mob/var/emote_allowed = 1
/mob/var/computer_id = null
/mob/var/lastattacker = null
/mob/var/lastattacked = null
/mob/var/attack_log = list( )
/mob/var/already_placed = 0.0
/mob/var/other_mobs = null
/mob/var/poll_answer = 0.0
/mob/var/sdisabilities = 0
/mob/var/disabilities = 0
/mob/var/prev_move = null
/mob/var/monkeyizing = null
/mob/var/other = 0.0
/mob/var/eye_blind = null
/mob/var/eye_blurry = null
/mob/var/ear_damage = null
/mob/var/stuttering = null
/mob/var/real_name = null
/mob/var/blinded = null
/mob/var/bhunger = 0
/mob/var/ajourn = 0
/mob/var/rejuv = null
/mob/var/druggy = 0
/mob/var/confused = 0
/mob/var/antitoxs = null
/mob/var/plasma = null
/mob/var/resting = 0.0
/mob/var/canmove = 1.0
/mob/var/eye_stat = null
/mob/var/timeofdeath = 0.0
/mob/var/cpr_time = 1.0
/mob/var/drowsyness = 0.0
/mob/var/is_jittery = 0
/mob/var/jitteriness = 0
/mob/var/charges = 0.0
/mob/var/overeatduration = 0		// How long this guy is overeating
/mob/var/losebreath = 0.0
/mob/var/metabslow = 0	// Metabolism slowed
/mob/var/job = "assistant"
/mob/var/turf/SLOC = null
/mob/var/obj/machinery/machine = null
/mob/var/next_move = null
/mob/var/image/select_overlay
/mob/var/stat = 0
/mob/var/inertia_dir = 0
/mob/var/death = 0
/mob/var/intent = 1 //1 - help, 0 - harm
mob/var/atom/cur_object_i_see
mob/var/inlobby = 1
/mob/var/next_click= 0
//---------------------

//mob procs
//---------------------
/mob/New()
	..()
	select_overlay = image(usr)
	usr.select_overlay.override = 1
	if(length(landmarks) > 0)
		Move(pick(landmarks))

/mob/Bump(var/atom/A)
	if(istype(src, /mob/ghost) || !client)
		return
	if(istype(A, /obj/structure))
		var/obj/structure/S = A
		if(S.anchored == 0 && S.density == 1)
			if(!istype(A, /obj/structure/closet))
				step(S, dir, 64)
		else
			if(onstructure == 1 || myjetpack == 1)
				pixel_z = S.pixelzheight
				S.move_on(src)

	if(istype(A, /mob))
		if(A.density == 1)
			if(intent == 0)
				var/mob/simulated/living/humanoid/H = src
				if(H.client)
					if(H.client.run_intent < 4)
						step(A, dir, 64)
						if(prob(50))
							H << "\red You trying to knock down [A]"
							H.resting()
						if(prob(25))
							if(istype(A, /mob/simulated/living/humanoid))
								var/mob/simulated/living/humanoid/A2 = A
								A2.resting()
								H << "\red You knock down [A]"
				else
					step(A, dir, 64)
			else
				A.density = 0
				step(src, turn(A.dir, 180), 64)
				step(A, dir, 64)
				A.density = 1

	if(istype(A, /obj/machinery/airlock))
		var/obj/machinery/airlock/A_LOCK = A
		var/turf/simulated/floor/T = A.loc
		if(A_LOCK.charge == 0)
			return
		else
			if(istype(src, /mob/simulated/living/humanoid))
				var/mob/simulated/living/humanoid/user = src
				if(user.id && A_LOCK.ID.check_id(user.id))
					if(istype(A_LOCK, /obj/machinery/airlock/brig/briglock))
						return
					if(A_LOCK.close)
						A_LOCK.open()
					else
						A_LOCK.close()
					if(istype(A.loc, /turf/simulated))
						T.update_air_properties()

/mob/verb/respawn()
	if(istype(src, /mob/ghost))
		var/mob/new_player/M = new()
		M.key = key

/mob/verb/who()
	set name = "Who"
	set category = "OOC"
	usr << "players in game: "
	for(var/mob/M in world)
		if(M.client)
			usr << M.ckey

/mob/verb/OOC(msg as text)
	set name = "OOC"
	set category = "OOC"
	if(msg)
		if(!findtext(msg," ",1,2))
			world << "<FONT COLOR=#E726E3> OOC [usr.ckey]: [fix255(msg)]"

/mob/verb/run_intent()
	usr.client.switch_rintent()

/mob/verb/Change_Volume(newv as num)
	set name = "Change Volume(0-75)"
	set category = "OOC"
	if(newv > 75  || newv < 0) src << "\red Your number is out of 0-75 range."
	client.sound_volume = newv

/mob/verb/moveplus45degree()
	if(client)
		client.north = 0
		client.west = 0
		client.east = 0
		client.south = 0
		client.southwest = 0
		client.northwest = 0
		client.northeast = 0
		client.southeast = 0
		if(client.moving45 == 0)
			client.moving45 = 1
			return
		else
			client.moving45 = 0
			return

/mob/verb/vote_restart()
	set category = "OOC"
	if(restarted == 0)
		restarted = 1
		restartY.Cut()
		restartN.Cut()
		for(var/mob/M in world)
			if(M.client)
				M << "\red <h3>Vote for restart</h3>"
				M << "<a href='?src=\ref[reSTARter];yesorno=y'>Y</a>;<a href='?src=\ref[reSTARter];yesorno=n'>N</a>"
		spawn(500)
			if(length(restartY) > length(restartN))
				world << "\blue <h1>THE WORLD reSTARded***</h1>"
				world.Reboot(1)
				restarted = 0
			else
				world << "No restart"
				restarted = 0

/mob/verb/rotate_craft_object() //BUILDUING
	if(mycraft && mycraft_atom) //BUILDUING
		mycraft.dir = turn(mycraft.dir, 90) //BUILDUING
		mycraft_atom.dir = mycraft.dir //BUILDUING

/mob/proc/switch_intent()
	if(intent)
		intent = 0
		return
	else
		intent = 1
		return

/mob/proc/view_to_res()
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

/mob/proc/dream()
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

/mob/proc/myclick(var/atom/A)
	var/mob/simulated/living/humanoid/H = usr
	if(istype(H, /mob/simulated/living/humanoid))
		if(H.handcuffed == 0)
			var/obj/item/I = H.get_active_hand()

			if(H.throwing_mode == 1)
				if(H.hand && H.l_hand)
					var/obj/item/I2 = H.l_hand
					H.drop_item()
					I2.throw_hyuow_at(src, A, rand(4,9), 1)
					H.throwing_mode = 0
					H.TH.icon_state = "throw1"
				if(!H.hand && H.r_hand)
					var/obj/item/I2 = H.r_hand
					H.drop_item()
					I2.throw_hyuow_at(src, A, rand(4,9), 1)
					H.throwing_mode = 0
					H.TH.icon_state = "throw1"

			if(get_dist(src, A) < 2)
				if(istype(I, /obj/item/weapon/gun))
					I.afterattack(A)
				if(src in range(1, usr))
					if(!H.get_active_hand())
						A.attack_hand(usr)
					else
						if(A == H.get_active_hand())
							A.attack_self()
						else
							A.attackby(H.get_active_hand())
							if(I)
								I.afterattack(A, usr)
				else if(A.loc in range(1, usr))
					A.attack_hand(usr)

/mob/proc/show(var/atom/mybuild) //BUILDING
	if(istype(usr, /mob/simulated/living/humanoid)) //BUILDING
		var/mob/simulated/living/humanoid/H = usr //BUILDING
		H.CRFT.invisibility = 0 //BUILDING
	if(mycraft) //BUILDING
		client.screen.Remove(mycraft) //BUILDING
	mycraft = image(icon = mybuild.icon, icon_state = mybuild.icon_state, layer = 15) //BUILDING
	mycraft_atom = mybuild //BUILDING

/mob/proc/playsoundforme(sound/S as sound)
	if(client)
		usr << sound(S,0,0,0,client.sound_volume)

/mob/proc/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		A.ShiftClickOn()
		return

/mob/proc/check_topic(var/atom/ATOM)
	if(get_dist(src,ATOM) > 1)
		return 0
	else
		return 1
//---------------------

//procs(mob)
//-------------------
/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))