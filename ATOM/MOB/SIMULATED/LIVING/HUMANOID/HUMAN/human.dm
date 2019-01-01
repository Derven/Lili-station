/mob/simulated/living/humanoid/human
	var/icon/myhair

	proc/create(var/mob/new_player/player)
		key = player.key
		create_hud(client)
		job = player.pregame_job
		gender = player.gender
		name = player.pregame_name
		flavor = player.pregame_flavor
		myhair = player.pregame_hair

		if(gender == "male")
			icon_state = "mob"
		if(gender == "female")
			icon_state = "mob_f"

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

		overlays.Add(myhair)
		if(player.pregame_body_color == "black")
			icon -= rgb(100,100,100)
		density = 1