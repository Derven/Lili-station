/mob/simulated/living/monkey
	icon = 'mob.dmi'
	icon_state = "monkey"

	process()
		if(death == 0)
			blood_flow()
			updatehealth()

	death()
		death = 1
		src << "\red You are dead"
		if(client)
			client.screen.Cut()
		//STOP_PROCESSING(SSmobs, src)
		icon_state = "death_[icon_state]"
		var/mob/ghost/zhmur = new()
		zhmur.key = key
		if(client)
			Login()
		zhmur.loc = loc
		new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src.loc)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src.loc)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src.loc)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src.loc)
		overlays.Cut()
		for(var/mob/simulated/L in src)
			L.loc = src.loc
		return

	New()
		select_overlay = image(usr)
		overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
		overlay_cur.layer = 16
		overlay_cur.pixel_z = 5
		overlay_cur.pixel_x = -14
		usr.select_overlay.override = 1
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

		chest = new /datum/organ/external/chest(src)
		head = new /datum/organ/external/head(src)
		l_arm = new /datum/organ/external/arm/l_arm(src)
		r_arm = new /datum/organ/external/arm/r_arm(src)
		r_leg = new /datum/organ/external/leg/r_leg(src)
		l_leg = new /datum/organ/external/leg/l_leg(src)
		groin = new /datum/organ/external/groin(src)
		lungs = new /datum/organ/internal/lungs(src)
		heart = new /datum/organ/internal/heart(src)

		chest.owner = src
		head.owner = src
		r_arm.owner = src
		l_arm.owner = src
		r_leg.owner = src
		l_leg.owner = src
		groin.owner = src

		organs += chest
		organs += head
		organs += r_arm
		organs += l_arm
		organs += r_leg
		organs += l_leg
		organs += groin

		reagents.add_reagent("blood",300)
		START_PROCESSING(SSmobs, src)
		addai(src, /datum/AI/friends_animal/monkey)
		..()

/mob/simulated/living/monkey/proc/handle_temperature(var/datum/gas_mixture/environment)
	if(environment)
		var/environment_heat_capacity = environment.heat_capacity()
		var/transfer_coefficient = 1
		var/areatemp = environment.temperature
		if(abs(areatemp - bodytemperature) > 50)
			var/diff = areatemp - bodytemperature
			diff = diff / 5
			//world << "changed from [bodytemperature] by [diff] to [bodytemperature + diff]"
			bodytemperature += diff
		if(bodytemperature < initial(bodytemperature))
			bodytemperature += rand(1, 2)
		handle_temperature_damage(environment.temperature, environment_heat_capacity*transfer_coefficient)