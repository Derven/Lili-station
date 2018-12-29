/mob
	var/bruteloss = 0.0//Living
	var/fireloss = 0.0//Living

	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.firer != src)
			if(Proj.damage > 0)
				rand_damage(Proj.damage - rand(1,4), Proj.damage)
			else
				stunned += Proj.stun
			del(Proj)
			return 0

	proc/switch_intent()
		if(intent)
			intent = 0
			return
		else
			intent = 1
			return

	proc/heal_burn(var/vol)
		if(chest.brute_dam >= vol)
			chest.burn_dam -= vol

		if(head.brute_dam >= vol)
			head.burn_dam -= vol

		if(r_arm.brute_dam >= vol)
			r_arm.burn_dam -= vol

		if(l_arm.brute_dam >= vol)
			l_arm.burn_dam -= vol

		if(r_leg.brute_dam >= vol)
			r_leg.burn_dam -= vol

		if(l_leg.brute_dam >= vol)
			l_leg.burn_dam -= vol

		if(chest.brute_dam < vol)
			chest.burn_dam = vol

		if(head.brute_dam < vol)
			head.burn_dam = 0

		if(r_arm.brute_dam < vol)
			r_arm.burn_dam = 0

		if(l_arm.brute_dam < vol)
			l_arm.burn_dam = 0

		if(r_leg.brute_dam  < vol)
			r_leg.burn_dam = 0

		if(l_leg.brute_dam < vol)
			l_leg.burn_dam = 0

	proc/heal_brute(var/vol)
		if(chest.brute_dam >= vol)
			chest.brute_dam -= vol

		if(head.brute_dam >= vol)
			head.brute_dam -= vol

		if(r_arm.brute_dam >= vol)
			r_arm.brute_dam -= vol

		if(l_arm.brute_dam >= vol)
			l_arm.brute_dam -= vol

		if(r_leg.brute_dam >= vol)
			r_leg.brute_dam -= vol

		if(l_leg.brute_dam >= vol)
			l_leg.brute_dam -= vol

		if(chest.brute_dam < vol)
			chest.brute_dam = vol

		if(head.brute_dam < vol)
			head.brute_dam = 0

		if(r_arm.brute_dam < vol)
			r_arm.brute_dam = 0

		if(l_arm.brute_dam < vol)
			l_arm.brute_dam = 0

		if(r_leg.brute_dam  < vol)
			r_leg.brute_dam = 0

		if(l_leg.brute_dam < vol)
			l_leg.brute_dam = 0

	proc/death()
		death = 1
		src << "\red You are dead"
		if(client)
			client.screen.Cut()
		STOP_PROCESSING(SSmobs, src)
		rest()
		var/mob/ghost/zhmur = new()
		zhmur.key = key
		if(client)
			Login()
		zhmur.loc = loc
		return


/mob/proc/rand_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	apply_damage(rand(mind, maxd) - defense, "brute" , MY_PAIN, 0)

/mob/proc/rand_burn_damage(var/mind, var/maxd)
	var/MY_PAIN
	MY_PAIN = get_organ(pick("chest", "r_leg", "l_leg","r_arm", "l_arm"))
	apply_damage(rand(mind, maxd), "fire" , MY_PAIN, 0)

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
			organ.take_damage(damage, 0)
	UpdateDamageIcon()


	if(istype(def_zone, /datum/organ/external/chest))
		if(damage - blocked > 8)
			lungs.brute_dam += damage / 2
			heart.brute_dam += damage / 3

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

/mob/proc/attacked_by(var/obj/item/I, var/mob/simulated/living/humanoid/user, var/def_zone)
	user = usr
	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0

	if(istype(I, /obj/item/weapon/handcuffs))
		var/turf/cur_loc = loc
		if(usr.do_after(25))
			if(cur_loc == loc)
				user.drop_item_v()
				I.Move(src)
				handcuffed = 1
				for(var/mob/M in range(5, src))
					M.playsoundforme('handcuffs.ogg')
				return

	var/datum/organ/external/defen_zone
	if(client)
		defen_zone = get_organ(ran_zone(DF_ZONE.selecting))

	var/datum/organ/external/affecting = get_organ(ran_zone(user.ZN_SEL.selecting))
	var/hit_area = parse_zone(affecting.name)
	var/def_area
	if(def_zone && client)
		def_area = parse_zone(defen_zone.name)

	usr << "\red <B>[src] attacked [user] to [hit_area] by [I.name] !</B>"

	if((user != src))
		return 0

	if(istype(I, /obj/item/weapon/flasher))
		for(var/mob/M in range(3, src))
			M.playsoundforme('flash.ogg')
			M << "\red [user] blinds [src] with the flash!"
		rest()
		if(client)
			client.show_map = 0
			sleep(rand(3,9))
			client.show_map = 1
			sleep(rand(2,5))
			rest()
		run_intent()
	if(istype(I, /obj/item/weapon/fire_ext))
		for(var/mob/M in range(3, src))
			M.playsoundforme('smash2.ogg')

	if(!I.force)	return 0
	if(def_area)
		if(def_area == hit_area)
			I.force -= defense
			user << "\blue You block damage partially"
			usr << "\red [src] block damage partially!"
	apply_damage(I.force, I.damtype, affecting, 0)
	I.force = initial(I.force)

	stunned += I.stun

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

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching

/mob/proc/getBruteLoss()
	bruteloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_brute()
			bruteloss += dam
		else
			var/dam = E.get_brute()
			bruteloss += round(dam / 4)
	return bruteloss

/mob/proc/adjustBruteLoss(var/amount)
	bruteloss = max(bruteloss + amount, 0)

/mob/proc/getFireLoss()
	fireloss = 0
	for(var/datum/organ/external/E in organs)
		if(istype(E, /datum/organ/external/chest) || istype(E, /datum/organ/external/head) || istype(E, /datum/organ/external/groin))
			var/dam = E.get_burn()
			fireloss += dam
		else
			var/dam = E.get_burn()
			fireloss += round(dam / 4)
	return fireloss

/mob/proc/adjustFireLoss(var/amount)
	fireloss = max(fireloss + amount, 0)

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
			adjustFireLoss(damage/(blocked+1))
	UpdateDamageIcon()
	return 1

/mob/UpdateDamageIcon()
	return

/mob/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	for(var/datum/organ/external/O in organs)
		if(O.name == zone)
			return O
	return null