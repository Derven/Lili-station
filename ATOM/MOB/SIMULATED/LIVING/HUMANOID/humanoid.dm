/mob/simulated/living/humanoid
	var/throwing_mode = 0
	var/hand = null

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
	if(hand)
		LH.icon_state = "l_hand_a"
		RH.icon_state = "r_hand"
	else
		RH.icon_state = "r_hand_a"
		LH.icon_state = "l_hand"

/mob/simulated/living/humanoid/proc/drop_item_v()
	if (stat == 0)
		drop_item()
	return

/mob/simulated/living/humanoid/proc/parstunweak()
	if (sleeping || stunned || weakened) //Stunned etc.
		if (stunned > 0)
			stunned--
			if(l_hand || r_hand)
				drop_item_v()
				swap_hand()
				drop_item_v()
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
			drop_item_v()
			swap_hand()
			drop_item_v()