/mob/simulated/living/proc/getOxyLoss()
	return oxyloss

/mob/simulated/living/proc/adjustOxyLoss(var/amount)
	oxyloss = max(oxyloss + amount, 0)

/mob/simulated/living/proc/getToxLoss()
	return toxloss

/mob/simulated/living/proc/adjustToxLoss(var/amount)
	toxloss = max(toxloss + amount, 0)

/mob/simulated/living

	proc/blood_flow()
		heart.my_func()
		switch(heart.pumppower)
			if (80 to 90)
				if(prob(rand(2,5)))
					src << heart.pain_internal()
			if (50 to 80)
				if(prob(rand(5,15)))
					src << heart.pain_internal()
			if (30 to 50)
				if(prob(rand(10,15)))
					src << heart.pain_internal()
				if(sleeping == 0)
					sleeping()
			if (5 to 30)
				if(prob(rand(10,25)))
					src << heart.pain_internal()
					chest.brute_dam += rand(2,4)
					head.brute_dam += rand(2,4)
			if(0 to 5)
				death()

		if(H)
			H.clear_overlay()
			H.temppixels(round(H.cur_tnum))
			H.oxypixels(round(100 - oxyloss))
			H.healthpixels(round(health))

		if(prob(25))
			if(!reagents.has_reagent("blood", 280))
				reagents.add_reagent("blood", 20)

		if(prob(25))
			for(var/datum/organ/external/EX in organs)
				EX.blood_flow(src)

		if(!reagents.has_reagent("blood", 50))
			death()
			return

/mob/simulated/living/proc/updatehealth()
	if(src.nodamage)
		src.health = 100
		src.stat = 0
		return
	if(cloth == null || cloth.space_suit == 0)
		if(istype(src.loc, /turf/simulated/floor))
			var/turf/simulated/floor/F = src.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					Emote(pick("gasps", "cough"))
					oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				oxyloss += 2

		else if(istype(src.loc, /obj) && !istype(src.loc, /obj/structure/disposalholder))
			var/obj/O = src.loc
			var/turf/simulated/floor/F = O.loc
			var/datum/gas_mixture/G = F.return_air()
			if(lungs)
				if(G.oxygen - (lungs.my_func()/5 + rand(1,10)) < HUMAN_NEEDED_OXYGEN + heart.pumppower/1000)
					Emote(pick("gasps", "cough"))
					oxyloss += 1
				else
					if(oxyloss > 1)
						oxyloss -= 1
			else
				oxyloss += 2

		else
			Emote(pick("gasps", "cough"))
			oxyloss += 1
	if(oxyloss > 75)
		sleeping()

	src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
	if(health > 100)
		health = 100
	if(src.health < 0)
		src.health = 0
		death()
