/mob/var/usrcolor

client
	var/STFU_ghosts		//80+ people rounds are fun to admin when text flies faster than airport security
	var/STFU_radio		//80+ people rounds are fun to admin when text flies faster than airport security

mob
	robustness = 200
	step_size = 64
	layer = 18
	density = 1
	layer = 18.0
	animate_movement = 2
	flags = NOREACT
	var/datum/mind/mind
	var/hand = null
	var/list/obj/last_contents = list()
	//MOB overhaul
	//Not in use yet
	var/obj/organstructure/organStructure = null

	//Vars that have been relocated to organStructure
	//Vars that have been relocated to organStructure ++END
	var/obj/machinery/machine = null
	var
		language = ENG
		image/select_overlay
		damage_bonus = 0
		defense = 5
		revenge = 0
		image/hair
		turf/SLOC = null
	var/next_move = null
	var/nutrition = 400.0//Carbon
	var/lying
	var/nodamage = 0

	process()
		if(death == 0)
			SLOC = src.loc
			//set invisibility = 0
			//set background = 1
			var/datum/gas_mixture/environment = SLOC.return_air()
			var/SLOC_temperature = environment.temperature
			handle_pain()
			handle_stomach()
			handle_injury()
			handle_chemicals_in_body()
			handle_temperature(SLOC_temperature)
			if(client)
				client.MYZL()

	//Vars that should only be accessed via procs
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/obj/item/clothing/suit/cloth= null//Carbon
	var/obj/item/clothing/id/id= null//Carbon
	var/stat = 0
	var/atom/movable/pulling = null
	var/in_throw_hyuow_mode = 0

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/list/organs = list()

	proc/select_lang(var/rus_msg, var/eng_msg)
		switch(language)
			if(RUS)
				return rus_msg
			if(ENG)
				return eng_msg

/client/verb/windowclose(var/atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	//world << "windowclose: [atomref]"
	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		var/href = "close=1"
		if(hsrc)
			//world << "[src] Topic [href] [hsrc]"
			usr = src.mob
			src.Topic(href, params2list(href), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
		//world << "[src] was [src.mob.machine], setting to null"
		src.mob.machine = null
	return

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL
		obj/hud/health/H
		obj/hud/zone_sel_def/DF_ZONE
		obj/hud/cloth/CL
		//obj/hud/rose_of_winds/ROW
		obj/hud/hide_walls/HW
		obj/hud/act_intent/AC
		obj/hud/run_intent/RI
		obj/hud/id/ID
		obj/hud/switcher/SW
		obj/hud/rest/R
		obj/hud/movement/M
		obj/hud/back/B

	proc
		create_hud(var/client/C)
			if(C)
				LH = new(src)
				RH = new(src)
				DP = new(src)
				PULL = new(src)
				ZN_SEL = new(src)
				H = new(src)
				CL = new(src)
				AC = new(src)
				//ROW = new(src)
				HW = new(src)
				DF_ZONE = new(src)
				RI = new(src)
				ID = new(src)
				SW = new(src)
				R = new(src)
				M = new(src)
				B = new(src)

				C.screen.Add(LH)
				C.screen.Add(ID)
				C.screen.Add(RH)
				C.screen.Add(DP)
				C.screen.Add(PULL)
				C.screen.Add(ZN_SEL)
				C.screen.Add(CL)
				//C.screen.Add(ROW)
				C.screen.Add(HW)
				C.screen.Add(AC)
				C.screen.Add(DF_ZONE)
				C.screen.Add(RI)
				C.screen.Add(H)
				C.screen.Add(SW) //good hud in mood
				C.screen.Add(R)
				C.screen.Add(M)
				C.screen.Add(B)

/mob
	icon = 'mob.dmi'
	icon_state = "mob"
	layer = 15
	var/death = 0
	var/intent = 1 //1 - help, 0 - harm
	var/image/overlay_cur

	gender = MALE
	var/list/stomach_contents = list()

	var/brain_op_stage = 0.0
	var/eye_op_stage = 0.0
	var/appendix_op_stage = 0.0
	var/datum/organ/external/chest/chest
	var/datum/organ/external/head/head
	var/datum/organ/external/arm/l_arm/l_arm
	var/datum/organ/external/arm/r_arm/r_arm
	var/datum/organ/external/leg/r_leg/r_leg
	var/datum/organ/external/leg/l_leg/l_leg
	var/datum/organ/external/groin/groin
	//var/datum/disease2/disease/virus2 = null
	//var/list/datum/disease2/disease/resistances2 = list()
	var/antibodies = 0

	proc/handle_chemicals_in_body()
		if(reagents) reagents.metabolize(src)

	New()
		START_PROCESSING(SSmobs, src)
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

		..()

	Move()

		if(lying)
			return
		see_invisible = 16 * (ZLevel-1)
		var/turf/unsimulated/wall_east

		if(!istype(src, /mob/ghost))
			for(var/mob/mober in range(5, src))
				mober << 'steps.ogg'

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

		for(var/turf/unsimulated/wall/W in range(2, src))
			W.clear_for_all()

		if(!istype(loc, /turf/simulated/floor/stairs))
			pixel_z = (ZLevel-1) * 32

		var/oldloc = src.loc
		..()
		wall_east = get_step(src, EAST)
		var/turf/unsimulated/wall_south = get_step(src, SOUTH)

		if(wall_east && istype(wall_east, /turf/unsimulated/wall))
			var/turf/unsimulated/wall/my_wall = wall_east
			my_wall.hide_me()

		if(wall_south && istype(wall_south, /turf/unsimulated/wall))
			var/turf/unsimulated/wall/my_wall = wall_south
			my_wall.hide_me()

		if(src.pulling)
			if(!step_towards(src.pulling, src) && (get_dist(src.pulling, src) > 1))
				if(!step_towards(src.pulling, oldloc))
					update_pulling()

	proc/handle_stomach()
		spawn(0)
			for(var/mob/M in stomach_contents)
				if(M.loc != src)
					stomach_contents.Remove(M)
					continue
				if(istype(M, /mob) && stat != 2)
					if(M.stat == 2)
						M.death(1)
						stomach_contents.Remove(M)
						del(M)
						continue
					if(air_master.current_cycle%3==1)
						if(!M.nodamage)
							M.adjustBruteLoss(5)
						nutrition += 10

	//pain

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
									src << select_lang("\red Вам очень больно! Права&#255; нога болит", "\red You feel pain. Your right leg hurt")
								else
									src << select_lang("\red Вам очень больно! Лева&#255; нога болит", "\red You feel pain. Your left leg hurt")

					if(istype(O, /datum/organ/external/arm))
						if(O.brute_dam + O.burn_dam > 60)
							if(prob(40))
								if(istype(O, /datum/organ/external/arm/r_arm))
									if (hand)
										drop_item_v()
									else
										swap_hand()
									src << select_lang("\red Вам очень больно! Права&#255; рука болит", "\red You feel pain. Your right arm hurt")
								else
									if (!hand)
										drop_item_v()
									else
										swap_hand()
									src << select_lang("\red Вам очень больно! Лева&#255; рука болит", "\red You feel pain. Your left arm hurt")
								drop_item_v()

/atom/proc/relaymove()
	return

/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

/mob
	var/obj/lobby/lobby
	var/lobby_text
	var/sound/lobbysound = sound('title1.ogg')

	proc/create_lobby(var/client/C)
		if(C)
			C.screen += lobby

/mob/New()
	..()
	if(length(landmarks) > 0)
		Move(pick(landmarks))

/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
		<head> \
			<title> lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #200772; width: 100%; border: 4px double #FFDE40;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>Lili station</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				LANGUAGE <a href='?src=\ref[src];lang=eng'> ENG </a> / <a href='?src=\ref[src];lang=rus'> RUS </a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> exists([assist]) <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> needed(2) exists([botanist])<a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender needed(1) exists([bart]) <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> needed(2) exists([sec]) <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> needed(2) exists([engi])<a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> needed(2) exists([doc])<a href='?src=\ref[src];doc=0'>select</a><br> \
			</div> \
		</body> \
	</html>"
	usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")

/mob/proc/lobby_refresh()
	lobby_text = " \
	<html> \
		<head> \
			<title> Aurora lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #200772; width: 100%; border: 4px double #FFDE40;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>AURORA</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				LANGUAGE <a href='?src=\ref[src];lang=eng'> ENG </a> / <a href='?src=\ref[src];lang=rus'> RUS </a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> exists([assist]) <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> needed(2) exists([botanist])<a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender needed(1) exists([bart]) <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> needed(2) exists([sec]) <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> needed(2) exists([engi])<a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> needed(2) exists([doc])<a href='?src=\ref[src];doc=0'>select</a><br> \
			</div> \
		</body> \
	</html>"

client
	var/played = 0

/mob/Login()
	..()
	if(!istype(src, /mob/ghost))
		density = 0
		usr << "<h1><b>Wellcome to unique isometric station based on SS13 and named 'Lili station'.</b></h2>"
		lobby = new(usr)
		create_hud(usr.client)
		create_lobby(usr.client)
		assist += 1
		usr << lobbysound
		show_lobby()

//mob/var/atom/cur_object_i_give
mob/var/atom/cur_object_i_see
mob/var/inlobby = 1

mob/Stat()
	for(var/M in visible_containers)
		if(last_contents)
			statpanel("Contents", last_contents)
		if(cur_object_i_see)
			if(M == cur_object_i_see.type)
				last_contents = cur_object_i_see.contents
				if(!istype(cur_object_i_see, /mob) && cur_object_i_see && cur_object_i_see.contents.len > 0)
					statpanel("Contents", null) //top fix
					statpanel("Contents", cur_object_i_see.contents)
	//if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)

/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		if(ast == 1)
			wear_on_spawn(/obj/item/clothing/suit/assistant)
		if(brt == 1)
			wear_on_spawn(/obj/item/clothing/suit/bartender)
		if(dct == 1)
			wear_on_spawn(/obj/item/clothing/suit/med)
		if(eng == 1)
			wear_on_spawn(/obj/item/clothing/suit/eng_suit)
		if(sct == 1)
			wear_on_spawn(/obj/item/clothing/suit/security_suit)
		if(btn == 1)
			wear_on_spawn(/obj/item/clothing/suit/hydro_suit)
		usr << sound(null)
		usr << browse(null, "window=setup")
		Move(pick(jobmarks))
		radio_arrival()
		lobby.invisibility = 101
		density = 1
		if(name == key || name == "mob")
			name = rand_name(src)
		inlobby = 0

	if(href_list["name"] == "newname")
		usr.name = input("Choose a name for your character.",
			"Your Name",usr.name)
	if(href_list["enter"] == "nahoy")
		Logout()
	if(href_list["display"] == "show")
		usr.screen_res = input("Select the resolution.","Ваше разрешение", usr.screen_res) in screen_resolution
		view_to_res()
	if(href_list["hair"] == "new")
		var/hair_state = input("Select the hairs.","Your hairs", hair) in hairs
		if(hair)
			overlays.Remove(hair)
		hair = image('mob.dmi', hair_state)
		hair.layer = initial(layer) + 5
		overlays.Add(hair)
	if(href_list["gender"] == "male")
		icon_state = "mob"
	if(href_list["gender"] == "female")
		icon_state = "mob_f"
	if(href_list["lang"] == "rus")
		language = RUS
	if(href_list["lang"] == "eng")
		language = ENG
	if(href_list["color"] == "select")
		usr.usrcolor = input(usr, "Please select color.", "color") as color
	//jobs SHIT rewrite pls
	if(href_list["assist"] == "0")
		if(ast == 0)
			assist += 1
			ast = 1
			if(btn > 0)
				botanist -= 1
				btn = 0
			if(sct > 0)
				sct = 0
				sec -= 1
			if(dct > 0)
				dct = 0
				doc -= 1
			if(brt > 0)
				brt = 0
				bart -= 1
			if(eng > 0)
				eng = 0
				engi -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is assistant now or no vacancies!"

	if(href_list["botanist"] == "0")
		if(btn == 0 || botanist == 2)
			botanist += 1
			btn = 1
			if(ast > 0)
				assist -= 1
				ast = 0
			if(sct > 0)
				sct = 0
				sec -= 1
			if(dct > 0)
				dct = 0
				doc -= 1
			if(brt > 0)
				brt = 0
				bart -= 1
			if(eng > 0)
				eng = 0
				engi -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is botanist now or no vacancies!"

	if(href_list["sec"] == "0")
		if(sct == 0 || sec == 2)
			sec += 1
			sct = 1
			if(ast > 0)
				assist -= 1
				ast = 0
			if(btn > 0)
				btn = 0
				botanist -= 1
			if(dct > 0)
				dct = 0
				doc -= 1
			if(brt > 0)
				brt = 0
				bart -= 1
			if(eng > 0)
				eng = 0
				engi -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is security now or no vacancies!"

	if(href_list["eng"] == "0")
		if(eng == 0 || engi == 2)
			engi += 1
			eng = 1
			if(ast > 0)
				assist -= 1
				ast = 0
			if(btn > 0)
				btn = 0
				botanist -= 1
			if(dct > 0)
				dct = 0
				doc -= 1
			if(brt > 0)
				brt = 0
				bart -= 1
			if(sct > 0)
				sct = 0
				sec -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is engineer now or no vacancies!"

	if(href_list["doc"] == "0")
		if(dct == 0 || doc == 2)
			doc += 1
			dct = 1
			if(ast > 0)
				assist -= 1
				ast = 0
			if(btn > 0)
				btn = 0
				botanist -= 1
			if(engi > 0)
				eng = 0
				engi -= 1
			if(brt > 0)
				brt = 0
				bart -= 1
			if(sct > 0)
				sct = 0
				sec -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is doctor now or no vacancies!"

	if(href_list["bart"] == "0")
		if(brt == 0 || bart == 1)
			bart +=1
			brt = 1
			if(ast > 0)
				assist -= 1
				ast = 0
			if(btn > 0)
				btn = 0
				botanist -= 1
			if(engi > 0)
				eng = 0
				engi -= 1
			if(dct > 0)
				dct = 0
				doc -= 1
			if(sct > 0)
				sct = 0
				sec -= 1
			lobby_refresh()
			usr << browse(null, "window=setup")
			usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
		else
			usr << "\red Your job is bartneder now or no vacancies!"

	return
/*
	if(href_list["assist"] == "0")
		assist = 1
	if(href_list["botanist"] == "0")
		botanist = 1
	if(href_list["sec"] == "0")
		sec = 1
	if(href_list["eng"] == "0")
		engi = 1
	if(href_list["doc"] == "0")
		doc = 1
	if(href_list["bart"] == "0")
		bart =1
*/
	//jobs