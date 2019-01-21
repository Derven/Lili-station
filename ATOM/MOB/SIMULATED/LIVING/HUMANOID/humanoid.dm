/mob/simulated/living/humanoid
	var/throwing_mode = 0
	var/hand = null
	var/image/hair
	var/lying
	var/handcuffed = 0
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/storage/box/backpack/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/obj/item/clothing/suit/cloth= null//Carbon
	var/obj/item/clothing/id/id= null//Carbon
	var/in_throw_hyuow_mode = 0
	var/flavor
	var //HUD
		obj/hud/drop/DP
		obj/hud/health/H
		obj/hud/cloth/CL
		obj/hud/id/ID
		obj/hud/switcher/SW
		obj/hud/rest/R
		obj/hud/movement/M
		obj/hud/back/B
		obj/hud/swap/S
		obj/hud/backpack/BP
		obj/hud/throwbutton/TH
		obj/hud/sleepbut/SB
		obj/hud/black/BL
		obj/hud/drive/DRV
		obj/hud/rotate/RTT
		obj/hud/craft/CRFT


	examine()
		usr << "...[name] - [gender]"
		if(cloth)
			usr << ">>> suit: [cloth]"
		if(id)
			usr << ">>> id card: [id]"
		if(back)
			usr << ">>> backpack: [back]"
		if(flavor)
			usr << ">>> [fix255(flavor)]..."

	Move()

		if((lying && mypool == 0) || (handcuffed == 1 && mypool == 1))
			return
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

		if(!istype(loc, /turf/simulated/floor/stairs))
			pixel_z = (ZLevel-1) * 32

		var/oldloc = src.loc
		..()
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

	create_hud(var/client/C)
		if(C)

			for(var/datum/organ/external/EX in organs)
				EX.create_hud(C)

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
			M = new(src)
			B = new(src)
			S = new(src)
			BP = new(src)
			TH = new(src)
			SB = new(src)
			BL = new(src)
			DRV = new(src)
			RTT = new(src)
			CRFT = new(src)
			update_hud(C)

	proc/update_hud(var/client/C)
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
		C.screen.Add(M)
		C.screen.Add(B)
		C.screen.Add(S)
		C.screen.Add(BP)
		BP.update_slot(back)
		C.screen.Add(TH)
		C.screen.Add(SB)
		C.screen.Add(BL)
		C.screen.Add(SW)
		C.screen.Add(DRV)
		C.screen.Add(RTT)
		C.screen.Add(CRFT)

		for(var/datum/organ/external/EX in organs)
			EX.update_hud(C)


	Login()
		if(length(usr.client.screen) == 0)
			update_hud(usr.client)
			..()

	proc/u_equip(obj/item/W as obj)
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
						heart.activate_stimulators(/datum/heart_stimulators/hard_sedative)

				handle_temperature_damage(chest, environment.temperature, environment_heat_capacity*transfer_coefficient)

	process()
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
			heart.pumppower = 0

	proc/handle_injury()
		spawn(0)
			blood_flow()
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

/mob/simulated/living/humanoid/proc/get_active_hand()
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
			if(heart.pumppower < 145 && !lying)
				resting()
		if (stunned <= 0 && lying)
			resting()
		if (weakened > 0)
			weakened--
			if(!lying)
				resting()
		if (sleeping == 1)
			if(!lying)
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

/mob/simulated/living/humanoid/verb/rest()
	set name = "Rest"
	set category = "IC"
	resting()

/mob/simulated/living/humanoid/proc/sleeping()
	sleeping = 1
	if(BL)
		BL.invisibility = 0
	SB.icon_state = "sleep2"
	if(!lying)
		resting()

/mob/simulated/living/humanoid/proc/awake()
	sleeping = 0
	if(BL)
		BL.invisibility = 101
	SB.icon_state = "sleep1"
	if(lying)
		resting()
