/proc/ran_zone(zone, probability)
	zone = check_zone(zone)
	if(!probability)	probability = 90
	if(probability == 100)	return zone

	if(zone == "chest")
		if(prob(probability))	return "chest"
		var/t = rand(1, 9)
		switch(t)
			if(1 to 3)	return "head"
			if(4 to 6)	return "l_arm"
			if(7 to 9)	return "r_arm"

	if(prob(probability * 0.75))	return zone
	return "chest"

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(canstun)
		stunned = max(amount,0)
	return

/mob/proc/AdjustStunned(amount)
	if(canstun)
		stunned = max(stunned + amount,0)
	return

/mob/proc/Weaken(amount)
	if(canweaken)
		weakened = max(max(weakened,amount),0)
	return

/mob/proc/SetWeakened(amount)
	if(canweaken)
		weakened = max(amount,0)
	return

/mob/proc/AdjustWeakened(amount)
	if(canweaken)
		weakened = max(weakened + amount,0)
	return

/mob/proc/Paralyse(amount)
	paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetParalysis(amount)
	paralysis = max(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	paralysis = max(paralysis + amount,0)
	return

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching

/mob/proc/getBruteLoss()
	return bruteloss

/mob/proc/adjustBruteLoss(var/amount)
	bruteloss = max(bruteloss + amount, 0)

/mob/proc/getOxyLoss()
	return oxyloss

/mob/proc/adjustOxyLoss(var/amount)
	oxyloss = max(oxyloss + amount, 0)

/mob/proc/setOxyLoss(var/amount)
	oxyloss = amount

/mob/proc/getToxLoss()
	return toxloss

/mob/proc/adjustToxLoss(var/amount)
	toxloss = max(toxloss + amount, 0)

/mob/proc/setToxLoss(var/amount)
	toxloss = amount

/mob/proc/getFireLoss()
	return fireloss

/mob/proc/adjustFireLoss(var/amount)
	fireloss = max(fireloss + amount, 0)

/mob/proc/getCloneLoss()
	return cloneloss

/mob/proc/adjustCloneLoss(var/amount)
	cloneloss = max(cloneloss + amount, 0)

/mob/proc/setCloneLoss(var/amount)
	cloneloss = amount

/mob/proc/getBrainLoss()
	return brainloss

/mob/proc/adjustBrainLoss(var/amount)
	brainloss = max(brainloss + amount, 0)

/mob/proc/setBrainLoss(var/amount)
	brainloss = amount

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/UpdateDamageIcon()
		return

/mob/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(istype(E, /datum/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
	else
		return 0
	return

// new damage icon system
// now constructs damage icon for each organ from mask * damage field

/mob/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if(!damage || (blocked >= 2))	return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage/(blocked+1))
		if(BURN)
			if(mutations & COLD_RESISTANCE)	damage = 0
			adjustFireLoss(damage/(blocked+1))
		if(TOX)
			adjustToxLoss(damage/(blocked+1))
		if(OXY)
			adjustOxyLoss(damage/(blocked+1))
		if(CLONE)
			adjustCloneLoss(damage/(blocked+1))
	UpdateDamageIcon()
	updatehealth()
	return 1

/mob/proc/updatehealth()
	if(!src.nodamage)
		src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss() - src.getCloneLoss()
	else
		src.health = 100
		src.stat = 0

/mob/UpdateDamageIcon()
	del(body_standing)
	body_standing = list()
	del(body_lying)
	body_lying = list()
	for(var/datum/organ/external/O in organs)
		var/icon/DI = new /icon('dam_human.dmi', O.damage_state)			// the damage icon for whole human
		DI.Blend(new /icon('dam_mask.dmi', O.icon_name), ICON_MULTIPLY)		// mask with this organ's pixels
	//		world << "[O.icon_name] [O.damage_state] \icon[DI]"
		body_standing += DI
		DI = new /icon('dam_human.dmi', "[O.damage_state]-2")				// repeat for lying icons
		DI.Blend(new /icon('dam_mask.dmi', "[O.icon_name]2"), ICON_MULTIPLY)
	//		world << "[O.r_name]2 [O.d_i_state]-2 \icon[DI]"
		body_lying += DI


/mob/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	for(var/datum/organ/external/O in organs)
		if(O.name == zone)
			return O
	return null

/proc/check_zone(zone)
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
		if("l_hand")
			zone = "l_arm"
		if("r_hand")
			zone = "r_arm"
		if("l_foot")
			zone = "l_leg"
		if("r_foot")
			zone = "r_leg"
		if("groin")
			zone = "chest"
	return zone

/mob/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if((damagetype != BRUTE) && (damagetype != BURN))
		..(damage, damagetype, def_zone, blocked)
		return 1

	if(blocked >= 2)	return 0

	var/datum/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))
	if(!organ)	return 0
	if(blocked)
		damage = (damage/(blocked+1))

	switch(damagetype)
		if(BRUTE)
			organ.take_damage(damage, 0)
		if(BURN)
			organ.take_damage(0, damage)
	UpdateDamageIcon()
	updatehealth()
	return 1

/proc/parse_zone(zone)
	if(zone == "r_hand") return "right hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_arm") return "left arm"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_leg") return "right leg"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "r_foot") return "right foot"
	else return zone

/mob/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 2))	return 0
	switch(effecttype)
		if(WEAKEN)
			Weaken(effect/(blocked+1))
		if(PARALYZE)
			Paralyse(effect/(blocked+1))
		if(IRRADIATE)
			radiation += effect//Rads auto check armor
		if(STUTTER)
			if(canstun) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect/(blocked+1)))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect/(blocked+1)))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect/(blocked+1)))
	UpdateDamageIcon()
	updatehealth()
	return 1

/mob/proc/attacked_by(var/obj/item/I, var/mob/user, var/def_zone)
	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0

	var/datum/organ/external/affecting = get_organ(ran_zone(user.ZN_SEL.selecting))
	var/hit_area = parse_zone(affecting.name)

	usr << "\red <B>[src] атакован(а) [user] в [hit_area] с помощью [I.name] !</B>"

	if((user != src))
		return 0

	if(!I.force)	return 0
	apply_damage(I.force, I.damtype, affecting, 0)

	if((I.damtype == BRUTE) && prob(25 + (I.force * 2)))

		switch(hit_area)
			if("head")//Harder to score a stun but if you do it lasts a bit longer
				if(prob(I.force))
					apply_effect(20, PARALYZE, 0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force + 10)))
					apply_effect(5, WEAKEN, 0)

	src.UpdateDamageIcon()

/mob/proc/upd_status(var/datum/organ/external/O)
	var/return_color

	if(O.brute_dam + O.burn_dam < 20)
		return_color = "#00FF21" //good

	if(O.brute_dam + O.burn_dam > 20)
		return_color = "#FFD800" //bad

	if(O.brute_dam + O.burn_dam > 70)
		return_color = "#FF0000" //very bad

	if(O.brute_dam + O.burn_dam > 100)
		return_color = "#FF006E" //pizdec

	return return_color