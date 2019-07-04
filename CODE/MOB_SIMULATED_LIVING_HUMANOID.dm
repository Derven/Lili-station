// /mob/simulated/living/humanoid vars
//---------------------
/mob/simulated/living/humanoid/var/throwing_mode = 0
/mob/simulated/living/humanoid/var/hand = null
/mob/simulated/living/humanoid/var/image/hair
/mob/simulated/living/humanoid/var/lying
/mob/simulated/living/humanoid/var/handcuffed = 0
/mob/simulated/living/humanoid/var/is_dizzy = 0
/mob/simulated/living/humanoid/var/obj/item/l_hand = null//Living
/mob/simulated/living/humanoid/var/obj/item/r_hand = null//Living
/mob/simulated/living/humanoid/var/obj/item/weapon/storage/box/backpack/back = null//Human/Monkey
/mob/simulated/living/humanoid/var/obj/item/weapon/tank/internal = null//Human/Monkey
/mob/simulated/living/humanoid/var/obj/item/weapon/storage/s_active = null//Carbon
/mob/simulated/living/humanoid/var/obj/item/clothing/mask/wear_mask = null//Carbon
/mob/simulated/living/humanoid/var/obj/item/clothing/suit/cloth= null//Carbon
/mob/simulated/living/humanoid/var/obj/item/clothing/PDA/PDA = null
/mob/simulated/living/humanoid/var/obj/item/clothing/helmet/cap = null
/mob/simulated/living/humanoid/var/obj/item/clothing/id/id= null//Carbon
/mob/simulated/living/humanoid/var/in_throw_hyuow_mode = 0
/mob/simulated/living/humanoid/var/flavor
/mob/simulated/living/humanoid/var/obj/hud/drop/DP //HUD
/mob/simulated/living/humanoid/var/obj/hud/health/H //HUD
/mob/simulated/living/humanoid/var/obj/hud/stamina/STAMINABAR //HUD
/mob/simulated/living/humanoid/var/obj/hud/cloth/CL //HUD
/mob/simulated/living/humanoid/var/obj/hud/head/CAP //HUD
/mob/simulated/living/humanoid/var/obj/hud/id/ID //HUD
/mob/simulated/living/humanoid/var/obj/hud/switcher/SW //HUD
/mob/simulated/living/humanoid/var/obj/hud/rest/R //HUD
/mob/simulated/living/humanoid/var/obj/hud/back/B //HUD
/mob/simulated/living/humanoid/var/obj/hud/hide/HIDE //HUD
/mob/simulated/living/humanoid/var/obj/hud/show/SHOW //HUD
/mob/simulated/living/humanoid/var/obj/hud/swap/S //HUD
/mob/simulated/living/humanoid/var/obj/hud/backpack/BP //HUD
/mob/simulated/living/humanoid/var/obj/hud/throwbutton/TH //HUD
/mob/simulated/living/humanoid/var/obj/hud/sleepbut/SB //HUD
/mob/simulated/living/humanoid/var/obj/hud/black/BL //HUD
/mob/simulated/living/humanoid/var/obj/hud/drive/DRV //HUD
/mob/simulated/living/humanoid/var/obj/hud/rotate/RTT //HUD
/mob/simulated/living/humanoid/var/obj/hud/craft/CRFT //HUD
/mob/simulated/living/humanoid/var/obj/hud/glitch/GLTCH //HUD
/mob/simulated/living/humanoid/var/obj/hud/PDA/PPDDAA //HUD
//---------------------

// /mob/simulated/living/humanoid procs
//---------------------
/mob/simulated/living/humanoid/process()
	if(death == 0)
		SLOC = src.loc
		//set invisibility = 0
		//set background = 1
		var/datum/gas_mixture/environment = SLOC.return_air()
		handle_pain()
		handle_stomach()
		handle_injury()
		handle_chemicals_in_body()
		handle_temperature(environment)
		parstunweak()
		if(client)
			client.MYZL()
		updatehealth()
	else
		if(heart)
			heart.pumppower = 0
	myspaceisperfect()

/mob/simulated/living/humanoid/Move()
	if((lying && mypool == 0) || (handcuffed == 1 && mypool == 1))
		return

	var/atom/A = src.loc

	see_invisible = 16 * (ZLevel-1)
	var/turf/simulated/wall_east

	for(var/turf/simulated/floor/roof/RF in oview())
		RF.hide(usr)

	if(ZLevel == 2)
		for(var/turf/simulated/floor/roof/RF in oview())
			RF.show(usr)

	if(usr && usr.client)
		if(dir == 2)
			wall_east = locate(usr.x + 1, usr.y - 2, usr.z)

		if(dir == 1)
			wall_east = locate(usr.x + 1, usr.y, usr.z)

	for(var/turf/simulated/wall/W in range(2, src))
		W.clear_for_all()

	//if(!istype(loc, /turf/simulated/floor/stairs))
	//	pixel_z = (ZLevel-1) * 32

	var/oldloc = src.loc
	..()

	if ((A != src.loc && A && A.z == src.z))
		src.last_move = get_dir(A, src.loc)

	wall_east = get_step(src, EAST)
	var/turf/simulated/wall_south = get_step(src, SOUTH)

	if(wall_east && istype(wall_east, /turf/simulated/wall))
		var/turf/simulated/wall/my_wall = wall_east
		my_wall.hide_me()

	if(wall_south && istype(wall_south, /turf/simulated/wall))
		var/turf/simulated/wall/my_wall = wall_south
		my_wall.hide_me()

	if(src.pulling)
		if(!step_towards(src.pulling, src) && (get_dist(src.pulling, src) > 1))
			if(!step_towards(src.pulling, oldloc))
				update_pulling()

	if(client)
		client.perspective = EDGE_PERSPECTIVE
		client.eye = client.mob
		src << browse(null, "window=computercam")

/mob/simulated/living/humanoid/examine()
	usr << "...[name] - [gender]"
	if(cloth)
		usr << ">>> suit: [cloth]"
	if(id)
		usr << ">>> id card: [id]"
	if(back)
		usr << ">>> backpack: [back]"
	if(flavor)
		usr << ">>> [fix255(flavor)]..."

/mob/simulated/living/humanoid/create_hud(var/client/C)
	if(C)
		for(var/datum/organ/external/EX in organs)
			EX.create_hud(C)

		STAMINABAR = new(src)
		PULL = new (src)
		ZN_SEL = new (src)
		DF_ZONE = new(src)
		AC = new(src)
		RI = new(src)
		DP = new(src)
		H = new(src)
		CL = new(src)
		ID = new(src)
		SW = new(src)
		R = new(src)
		B = new(src)
		S = new(src)
		BP = new(src)
		CAP = new(src)
		HIDE = new(src)
		SHOW = new(src)
		TH = new(src)
		SB = new(src)
		BL = new(src)
		DRV = new(src)
		RTT = new(src)
		CRFT = new(src)
		GLTCH = new(src)
		PPDDAA = new(src)
		update_hud(C)

/mob/simulated/living/humanoid/Login()
	if(length(usr.client.screen) == 0)
		update_hud(usr.client)
		..()

/mob/simulated/living/humanoid/verb/Say(msg as text)
	set name = "Say"
	set category = "IC"
	sleep(rand(1,2))
	if(!findtext(msg," ",1,2) && msg)
		overlays.Add(overlay_cur)
		for(var/mob/M in range(5, src))
			if(death == 0)
				M << "[src] says, \"[fix255(msg)]\""
			for(var/obj/item/device/radio/hr in M.contents)
				tell_me_more(name, hr.RADIOCURCUIT, fix255(msg))
		sleep(8)
		overlays.Remove(overlay_cur)
	for(var/obj/machinery/radio/intercom/I in range(7, src))
		tell_me_more(name, I, fix255(msg))
	return fix255(msg)

/mob/simulated/living/humanoid/verb/check_pulse()
	set src = range(1)
	if(heart)
		usr << "[src] pulse is [(heart.pumppower / 100) * 60] per minute"

/mob/simulated/living/humanoid/verb/push_up(var/mynum as num)
	var/oldnum = 0
	var/pushup = 1
	while(lying == 1 && mynum > 0 && stamina > 10 && pushup == 1)
		mynum -= 1
		oldnum += 1
		stamina -= rand(1,5)
		pixel_z += 3
		sleep(3)
		pixel_z = 0
		for(var/mob/M in range(5, src))
			M << "\red [src] did [oldnum] pushups"
	pushup = 0

/mob/simulated/living/humanoid/verb/rest()
	set name = "Rest"
	set category = "IC"
	resting()

/mob/simulated/living/humanoid/proc/alcotrip()
	is_dizzy = 1
	while(dizziness > 100)
		if(client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0

/mob/simulated/living/humanoid/proc/update_hud(var/client/C)
	if(C && C.screen && STAMINABAR)
		C.screen.Add(STAMINABAR)
		C.screen.Add(DF_ZONE)
		C.screen.Add(PULL)
		C.screen.Add(ZN_SEL)
		C.screen.Add(AC)
		C.screen.Add(RI)
		C.screen.Add(DP)
		C.screen.Add(H)
		C.screen.Add(CL)
		CL.update_slot(cloth)
		C.screen.Add(ID)
		ID.update_slot(id)
		C.screen.Add(R)
		C.screen.Add(B)
		C.screen.Add(S)
		C.screen.Add(BP)
		C.screen.Add(HIDE)
		C.screen.Add(SHOW)
		BP.update_slot(back)
		C.screen.Add(TH)
		C.screen.Add(CAP)
		C.screen.Add(SB)
		C.screen.Add(BL)
		C.screen.Add(SW)
		C.screen.Add(DRV)
		C.screen.Add(RTT)
		C.screen.Add(CRFT)
		C.screen.Add(GLTCH)
		C.screen.Add(PPDDAA)

		for(var/datum/organ/external/EX in organs)
			EX.update_hud(C)
	else
		create_hud(client)

/mob/simulated/living/humanoid/proc/u_equip(obj/item/W as obj)
	if (W == r_hand)
		r_hand = null
		if(W)
			W.del_inhand(usr)

	else if (W == l_hand)
		l_hand = null
		if(W)
			W.del_inhand(usr)

	else if (W == cloth)
		cloth = null

	else if (W == PDA)
		PDA = null

	else if (W == cap)
		cap = null
		overlays -= CAP.helmetoverlay

	else if (W == back)
		back = null
		overlays -= BP.backoverlay
		var/obj/item/weapon/storage/box/backpack/jetpack/JP = W
		JP.jetpacked = null
		src.myjetpack = 0

	else if (W == id)
		id = null

/mob/simulated/living/proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
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

/mob/simulated/living/humanoid/proc/handle_temperature(var/datum/gas_mixture/environment)
	if(cloth == null || cloth.space_suit == 0)
		if(H)
			H.clear_overlay()
			H.temppixels(round(bodytemperature))
			H.oxypixels(round(100 - oxyloss))
			STAMINABAR.staminapixels(round(stamina))
			H.healthpixels(round(health))
		if(environment)
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
					if(heart)
						heart.activate_stimulators(/datum/heart_stimulators/hard_sedative)
			handle_temperature_damage(chest, environment.temperature, environment_heat_capacity*transfer_coefficient)

/mob/simulated/living/humanoid/proc/handle_injury()
	spawn(0)
		blood_flow()
		if(stamina < 100)
			if(prob(85))
				stamina += 1
				STAMINABAR.staminapixels(round(stamina))
		if(istype(src, /mob) && stat != 2)
			for(var/datum/organ/external/O in organs)
				if(istype(O, /datum/organ/external/leg))
					if(O.brute_dam + O.burn_dam > 60)
						if(prob(40))
							rest()
							if(istype(O, /datum/organ/external/leg/r_leg))
								src << "\red You feel pain. Your right leg hurt"
							else
								src << "\red You feel pain. Your left leg hurt"

				if(istype(O, /datum/organ/external/arm))
					if(O.brute_dam + O.burn_dam > 60)
						if(prob(40))
							if(istype(O, /datum/organ/external/arm/r_arm))
								if (hand)
									drop_item_v()
								else
									swap_hand()
								src << "\red You feel pain. Your right arm hurt"
							else
								if (!hand)
									drop_item_v()
								else
									swap_hand()
								src << "\red You feel pain. Your left arm hurt"
							drop_item_v()

mob/simulated/living/humanoid/proc/get_active_hand()
	if (hand)
		return l_hand
	else
		return r_hand

/mob/simulated/living/humanoid/proc/put_in_hand(var/obj/item/I)
	if(!I) return
	I.loc = src
	if (hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/mob/simulated/living/humanoid/proc/put_in_inactive_hand(var/obj/item/I)
	I.loc = src
	if (!hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/mob/simulated/living/humanoid/verb/resist()
	if(handcuffed == 1)
		if(do_after(100))
			for(var/obj/item/weapon/handcuffs/HC in src)
				HC.Move(src.loc)
				handcuffed = 0

/mob/simulated/living/humanoid/proc/equipped()
	if (hand)
		return l_hand
	else
		return r_hand
	return

/mob/simulated/living/humanoid/proc/drop_item(var/atom/target)
	var/obj/item/W = equipped()
	if(W)
		W.del_inhand(src)
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
		if(istype(W, /obj/item/device/flashlight))
			if(W:on == 1)
				usr.sd_SetLuminosity(0)
				W:sd_SetLuminosity(5)
	return

/mob/simulated/living/humanoid/proc/swap_hand()
	src.hand = !( src.hand )
	if(l_arm && r_arm)
		if(hand)
			l_arm.HUD.icon_state = "l_hand_a"
			r_arm.HUD.icon_state = "r_hand"
		else
			r_arm.HUD.icon_state = "r_hand_a"
			l_arm.HUD.icon_state = "l_hand"

/mob/simulated/living/humanoid/proc/drop_item_v()
	if (stat == 0)
		drop_item()
	return

/mob/simulated/living/humanoid/proc/parstunweak()
	if (sleeping || stunned || weakened) //Stunned etc.
		if (stunned > 0)
			stunned--
			if(heart)
				if(heart.pumppower < 145 && !lying)
					if(parasite_control < 100)
						resting()
			else
				resting()
		if (stunned <= 0 && lying)
			resting()
		if (weakened > 0)
			weakened--
			if(!lying)
				if(parasite_control < 100)
					resting()
		if (sleeping == 1)
			if(!lying)
				if(parasite_control < 100)
					resting()
					lying = 1
			if(prob(2) && !dreaming)
				dream()

/mob/simulated/living/humanoid/proc/resting()
	if(!lying)
		src.transform = turn(src.transform, 90)
		lying = 1
		density = 0
		pixel_y = -32
		pixel_x = 22
		return
	else
		if(death == 0 && reagents.has_reagent("blood", 80))
			src.transform = turn(src.transform, -90)
			density = 1
			lying = 0
			pixel_y = 0
			pixel_x = 0
			return

/mob/simulated/living/humanoid/proc/sleeping()
	sleeping = 1
	if(BL)
		BL.invisibility = 0
	SB.icon_state = "sleep2"
	if(!lying)
		if(parasite_control < 100)
			resting()


/mob/simulated/living/humanoid/proc/awake()
	sleeping = 0
	if(BL)
		BL.invisibility = 101
	SB.icon_state = "sleep1"
	if(lying)
		resting()
