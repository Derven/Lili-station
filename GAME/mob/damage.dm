/mob/var/oxyloss = 0.0
/mob/var/toxloss = 0.0
/mob/var/brainloss = 0.0
/mob/var/ear_deaf = null
/mob/var/face_dmg = 0
/mob/var/halloss = 0
/mob/var/hallucination = 0
/mob/var/list/atom/hallucinations = list()

/mob
	var/bruteloss = 0.0//Living
	var/fireloss = 0.0//Living

	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.firer != src)
			rand_damage(Proj.damage - rand(1,4), Proj.damage)
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

	proc/blood_flow()
		var/obj/blood/BD

		if(prob(25))
			if(!reagents.has_reagent("blood", 280))
				reagents.add_reagent("blood", 20)

		if(prob(75))
			if(chest.brute_dam > 80)
				reagents.remove_reagent("blood", 20)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, епта
				BD = new(src.loc)

			if(head.brute_dam > 80)
				reagents.remove_reagent("blood", 18)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, епта
				BD = new(src.loc)

			if(r_leg.brute_dam > 80)
				reagents.remove_reagent("blood", 14)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, епта
				BD = new(src.loc)

			if(l_leg.brute_dam > 80)
				reagents.remove_reagent("blood", 14)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, епта
				BD = new(src.loc)

			if(r_arm.brute_dam > 80)
				reagents.remove_reagent("blood", 8)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, епта
				BD = new(src.loc)

			if(l_arm.brute_dam > 80)
				reagents.remove_reagent("blood", 8)
				src << select_lang("\red Вы тер&#255;ете немного крови", "You have the blood loss") //Хуй знает как еще перевести! Соре, еп
				BD = new(src.loc)

		if(!reagents.has_reagent("blood", 50))
			death()
			return

		if(H)
			if(reagents.has_reagent("blood", 300))
				src.H.icon_state = "health100"

			if(!reagents.has_reagent("blood", 270))
				src.H.icon_state = "health80"

			if(!reagents.has_reagent("blood", 180))
				src.H.icon_state = "health50"

			if(!reagents.has_reagent("blood", 140))
				src.H.icon_state = "health30"
				if(prob(35))
					if(!lying)
						resting()

			if(!reagents.has_reagent("blood", 80))
				src.H.icon_state = "health10"
				if(!lying)
					resting()

		if(BD)
			BD.pixel_z = (ZLevel - 1) * 32

	proc/death()
		death = 1
		src << select_lang("\red Ты умер. Пам-пам", "\red You are dead")
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

/mob/proc/attacked_by(var/obj/item/I, var/mob/user, var/def_zone)
	if((!I || !user) && istype(I, /obj/item/weapon/reagent_containers))	return 0

	var/datum/organ/external/defen_zone
	if(client)
		defen_zone = get_organ(ran_zone(DF_ZONE.selecting))

	var/datum/organ/external/affecting = get_organ(ran_zone(user.ZN_SEL.selecting))
	var/hit_area = parse_zone(affecting.name)
	var/def_area
	if(def_zone && client)
		def_area = parse_zone(defen_zone.name)

	usr << select_lang("\red <B>[src] атакован(а) [user] в [hit_area] с помощью [I.name] !</B>", "\red <B>[src] attacked [user] to [hit_area] by [I.name] !</B>")

	if((user != src))
		return 0

	if(istype(I, /obj/item/weapon/flasher))
		for(var/mob/M in range(3, src))
			M << 'flash.ogg'
			M << "\red [user] blinds [src] with the flash!"
		rest()
		if(usr.client)
			usr.client.show_map = 0
			sleep(rand(3,9))
			usr.client.show_map = 1
			sleep(rand(2,5))
			rest()
		run_intent()
	if(istype(I, /obj/item/weapon/fire_ext))
		for(var/mob/M in range(3, src))
			M << 'smash2.ogg'


	if(!I.force)	return 0
	if(def_area)
		if(def_area == hit_area)
			I.force -= defense
			user << select_lang("\blue Вы блокируете часть урона!", "\blue You block damage partially")
			usr << select_lang("\red [src] блокирует часть урона!", "\red [src] block damage partially!")
	apply_damage(I.force, I.damtype, affecting, 0)
	I.force = initial(I.force)
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
	return bruteloss

/mob/proc/adjustBruteLoss(var/amount)
	bruteloss = max(bruteloss + amount, 0)

/mob/proc/getFireLoss()
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