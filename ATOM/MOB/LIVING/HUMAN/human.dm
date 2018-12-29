/mob/human
	var/flavor
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
				wear_on_spawn(/obj/item/clothing/suit/assistant)
			if("bartender")
				wear_on_spawn(/obj/item/clothing/suit/bartender)
			if("doctor")
				wear_on_spawn(/obj/item/clothing/suit/med)
			if("engineer")
				wear_on_spawn(/obj/item/clothing/suit/eng_suit)
			if("security")
				wear_on_spawn(/obj/item/clothing/suit/security_suit)
			if("botanist")
				wear_on_spawn(/obj/item/clothing/suit/hydro_suit)
			if("captain")
				wear_on_spawn(/obj/item/clothing/suit/captain)

		overlays.Add(myhair)
		if(player.pregame_body_color == "black")
			icon -= rgb(100,100,100)
		density = 1