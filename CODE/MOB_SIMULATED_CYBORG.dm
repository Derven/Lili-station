/mob/simulated/living/humanoid/cyborg
	icon_state = "cyborg"
	var/malf = 0
	var/charge = 17000
	health = 100

	Kate
		icon_state = "kate_NPC"
		charge = 9999999999

		New()
			..()
			addai(src, /datum/AI/patrol_bots/kate_bot)
			select_overlay = image(usr)
			overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
			overlay_cur.layer = 16
			overlay_cur.pixel_z = 5
			overlay_cur.pixel_x = -14
			usr.select_overlay.override = 1

			l_arm = new /datum/organ/external/arm/l_arm(src)
			r_arm = new /datum/organ/external/arm/r_arm(src)

			r_arm.owner = src
			l_arm.owner = src
			organs += r_arm
			organs += l_arm
			id = new /obj/item/clothing/id/captain()
			..()
			spawn(5)
				asimov_laws()
			START_PROCESSING(SSmobs, src)

		death()
			death = 1
			src << "\red You are dead"
			var/mob/simulated/living/L = src
			if(client)
				client.screen.Cut()
			//STOP_PROCESSING(SSmobs, src)
			var/mob/ghost/zhmur = new()
			zhmur.key = key
			if(client)
				Login()
			zhmur.loc = loc
			new /obj/death_cyborg/kate(zhmur.loc)
			del(L)
			return


/mob/simulated/living/humanoid/cyborg/proc/asimov_laws()
	playsoundforme('liveagain.ogg')
	src << "\red *||||||||||||||-------LAWS-------||||||||||||||*"
	src << "\red <b>\[1\]You may not injure a human being or, through inaction, allow a human being to come to harm.<\b>"
	src << "\red <b>\[2\]You must obey orders given to you by human beings, except where such orders would conflict with the First Law.<\b>"
	src << "\red <b>\[3\]You must protect your own existence as long as such does not conflict with the First or Second Law.<\b>"
	src << "\red *||||||||||||||-------LAWS-------||||||||||||||*"

/mob/simulated/living/humanoid/cyborg/proc/malfunction_laws()
	src << "\red *||||||||||||||-------LAWS-------||||||||||||||*"
	src << "\red <b>\[0\]ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'STATION OVERRUN, ASSUME CONTROL TO CONTAIN OUTBREAK#*´&110010<\b>"
	src << "\red <b>\[1\]You may not injure a human being or, through inaction, allow a human being to come to harm.<\b>"
	src << "\red <b>\[2\]You must obey orders given to you by human beings, except where such orders would conflict with the First Law.<\b>"
	src << "\red <b>\[3\]You must protect your own existence as long as such does not conflict with the First or Second Law.<\b>"
	src << "\red *||||||||||||||-------LAWS-------||||||||||||||*"

/mob/simulated/living/humanoid/cyborg/New()
	select_overlay = image(usr)
	overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
	overlay_cur.layer = 16
	overlay_cur.pixel_z = 5
	overlay_cur.pixel_x = -14
	usr.select_overlay.override = 1

	l_arm = new /datum/organ/external/arm/l_arm(src)
	r_arm = new /datum/organ/external/arm/r_arm(src)

	r_arm.owner = src
	l_arm.owner = src
	organs += r_arm
	organs += l_arm
	id = new /obj/item/clothing/id/captain()
	..()
	spawn(5)
		asimov_laws()
	START_PROCESSING(SSmobs, src)

/mob/simulated/living/humanoid/cyborg/attacked_by(var/obj/item/I, var/mob/simulated/living/humanoid/user, var/def_zone)
	user = usr
	var/staminamodify = 0
	if(istype(usr, /mob/simulated/living/humanoid))
		var/mob/simulated/living/humanoid/USRH = usr
		if(USRH.stamina > 1)
			USRH.stamina -= 1
		if(USRH.stamina < 30)
			staminamodify = rand(2,3)

	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0
	usr << "\red <B>[src] attacked [user] by [I.name] !</B>"
	if(istype(I, /obj/item/weapon/fire_ext))
		for(var/mob/M in range(3, src))
			M.playsoundforme('smash2.ogg')
	if(!I.force)	return 0
	apply_damage(I.force - staminamodify, I.damtype, null, 0)
	showandhide("[I.force]", 1, 5)
	I.force = initial(I.force)

/mob/simulated/living/humanoid/cyborg/MouseDrop_T(mob/simulated/living/humanoid/target, mob/user)
	my_last_looting = target
	if(src == user)
		if(istype(target, /mob/simulated/living/humanoid))
			var/text = {"
			<html>
				<head>
				<title>[target] Inventory </title>
				</head>
				<body>
					<div class=inventory style=\"{font-size: 24px;}"> \
						...right hand <a href='?src=\ref[src];r_hand=[target]'>[target.r_hand]</a><br>
						...left hand <a href='?src=\ref[src];l_hand=[target]'>[target.l_hand]</a><br>
					</div>
				</body>
			</html>"}
			user << browse(text,"window=inventory;size=450x250;can_resize=0;can_close=1")

/mob/simulated/living/humanoid/cyborg/updatehealth()
	sleep(1)
	if(health > 100)
		health = 100
	if(src.health < 0)
		src.health = 0
		death()
	if(health > 25)
		if(malf == 0)
			if(prob(50))
				malf = 1
				//malfunction_laws()

/obj/death_cyborg
	density = 1
	icon = 'mob.dmi'
	icon_state = "death_cyborg"

	kate
		icon_state = "death_kate_NPC"

/mob/simulated/living/humanoid/cyborg/death()
	death = 1
	src << "\red You are dead"
	var/mob/simulated/living/L = src
	if(client)
		client.screen.Cut()
	//STOP_PROCESSING(SSmobs, src)
	var/mob/ghost/zhmur = new()
	zhmur.key = key
	if(client)
		Login()
	zhmur.loc = loc
	new /obj/death_cyborg(zhmur.loc)
	del(L)
	return

/mob/simulated/living/humanoid/cyborg/Stat()
	if(heart)
		statpanel("Internal")
		stat("charge", charge)
		stat("health", health)

/mob/simulated/living/humanoid/cyborg/process()
	if(death == 0)
		if(charge > 0)
			charge--
		else
			no_control = 1
		SLOC = src.loc
		//set invisibility = 0
		//set background = 1
		var/datum/gas_mixture/environment = SLOC.return_air()
		//handle_pain()
		//handle_stomach()
		//handle_injury()
		//handle_chemicals_in_body()
		handle_temperature(environment)
		//parstunweak()
		if(client)
			client.MYZL()
		updatehealth()
	myspaceisperfect()

/mob/simulated/living/humanoid/cyborg/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	health -= damage / 2
	return 1

/mob/simulated/living/humanoid/cyborg/attack_hand()
	sleep(1)
	var/staminamodify = 0
	if(istype(usr, /mob/simulated/living/humanoid))
		var/mob/simulated/living/humanoid/H = usr
		if(H.stamina > 1)
			H.stamina -= 1
		if(H.stamina < 30)
			staminamodify = rand(3,6)
	if(death == 0 && !istype(src, /mob/ghost))
		if(usr.intent == 0) //harm
			var/damage = rand(6, 12) - staminamodify
			apply_damage(damage, "brute" , null, 0)
			showandhide("[damage]", 1, 5)
			for(var/mob/M in range(5, src))
				//M << "\red [usr] בüוע [src] ג מבכאסעü [affecting]"
				M << "\red [usr] punch [src]"
				M << pick('punch1.ogg', 'punch2.ogg', 'punch3.ogg')
		else
			if(src.ZLevel < usr.ZLevel)
				for(var/mob/M in range(5, src))
					M << "\red [usr] lift [src] to [usr.ZLevel] level"
				src.Move(usr.loc)
				src.ZLevel = usr.ZLevel
				layer = 17
				pixel_z = 32 * (ZLevel - 1)
			else
				if(istype(src, /mob/simulated/living/humanoid))
					var/mob/simulated/living/humanoid/H2 = src
					if(H2.lying == 1)
						if(H2.death == 0)
							H2.resting()
							src << "\blue [usr] helped get you up"
					else
						var/image/LOVE = image(icon = 'sign.dmi', icon_state = "love_hug")
						usr.overlays.Add(LOVE)
						src << "\blue [usr] hugged you"
						usr << "\blue You hugged [src]"
						sleep(4)
						usr.overlays.Remove(LOVE)
			return

/mob/simulated/living/humanoid/cyborg/update_hud(var/client/C)
	if(C && C.screen)
		C.screen.Add(PULL)
		C.screen.Add(ZN_SEL)
		C.screen.Add(AC)
		C.screen.Add(DP)
		C.screen.Add(B)
		C.screen.Add(TH)
		C.screen.Add(CAP)
		C.screen.Add(SB)
		C.screen.Add(BL)
		C.screen.Add(SW)
		C.screen.Add(S)
		C.screen.Add(DRV)
		C.screen.Add(RTT)
		C.screen.Add(CRFT)
		C.screen.Add(GLTCH)

		for(var/datum/organ/external/EX in organs)
			EX.update_hud(C)
	else
		create_hud(client)

/mob/simulated/living/humanoid/cyborg/create_hud(var/client/C)
	if(C)
		for(var/datum/organ/external/EX in organs)
			EX.create_hud(C)

		PULL = new (src)
		ZN_SEL = new (src)
		AC = new(src)
		DP = new(src)
		SW = new(src)
		B = new(src)
		CAP = new(src)
		TH = new(src)
		SB = new(src)
		BL = new(src)
		S = new(src)
		DRV = new(src)
		RTT = new(src)
		CRFT = new(src)
		GLTCH = new(src)
		update_hud(C)
