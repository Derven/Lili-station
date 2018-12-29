/mob/simulated/living/humanoid/human
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

	Move()

		if(lying)
			return
		see_invisible = 16 * (ZLevel-1)
		var/turf/simulated/wall_east

		if(!istype(src, /mob/ghost))
			for(var/mob/mober in range(5, src))
				mober.playsoundforme('steps.ogg')

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