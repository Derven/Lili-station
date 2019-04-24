/mob/simulated/living/humanoid/human
	var/icon/myhair
	var/image/mydamage

	proc/create(var/mob/new_player/player)
		mydamage = image('mob.dmi')
		key = player.key
		gender = player.gender
		create_hud(client)
		job = player.pregame_job
		name = player.pregame_name
		flavor = player.pregame_flavor
		myhair = player.pregame_hair

		if(gender == "male")
			icon_state = "mob"
			mydamage.icon_state = "damage0_mob"
		if(gender == "female")
			icon_state = "mob_f"
			mydamage.icon_state = "damage0_fem"
		overlays += mydamage

		switch(player.pregame_job)
			if("assistant")
				wear_on_spawn(/obj/item/clothing/suit/assistant, /obj/item/clothing/id/assistant)
			if("bartender")
				wear_on_spawn(/obj/item/clothing/suit/bartender, /obj/item/clothing/id/assistant)
			if("doctor")
				wear_on_spawn(/obj/item/clothing/suit/med, /obj/item/clothing/id/doctor)
			if("engineer")
				wear_on_spawn(/obj/item/clothing/suit/eng_suit, /obj/item/clothing/id/assistant)
			if("security")
				wear_on_spawn(/obj/item/clothing/suit/security_suit, /obj/item/clothing/id/security)
			if("botanist")
				wear_on_spawn(/obj/item/clothing/suit/hydro_suit, /obj/item/clothing/id/assistant)
			if("captain")
				wear_on_spawn(/obj/item/clothing/suit/captain, /obj/item/clothing/id/captain)
			if("clown")
				wear_on_spawn(/obj/item/clothing/suit/clown, /obj/item/clothing/id/assistant)
			if("detective")
				wear_on_spawn(/obj/item/clothing/suit/detective, /obj/item/clothing/id/security)
		overlays.Add(myhair)
		if(player.pregame_body_color == "black")
			icon -= rgb(100,100,100)
		density = 1

	proc/update_mydamage(var/sumdam)
		overlays -= mydamage
		del(mydamage)
		mydamage = image('mob.dmi')
		mydamage.layer = 15
		if(gender == "male")
			if(sumdam < 30)
				mydamage.icon_state = "damage0_mob"
			if(sumdam >= 30 && sumdam < 60)
				mydamage.icon_state = "damage1_mob"
			if(sumdam >= 60 && sumdam < 80)
				mydamage.icon_state = "damage2_mob"
			if(sumdam >= 80)
				mydamage.icon_state = "damage3_mob"
		if(gender == "female")
			if(sumdam < 30)
				mydamage.icon_state = "damage0_fem"
			if(sumdam >= 30 && sumdam < 60)
				mydamage.icon_state = "damage1_fem"
			if(sumdam >= 60 && sumdam < 80)
				mydamage.icon_state = "damage2_fem"
			if(sumdam >= 80)
				mydamage.icon_state = "damage3_fem"
		overlays += mydamage