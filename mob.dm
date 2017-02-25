mob
	step_size = 64
	layer = 18
	density = 1
	layer = 4.0
	animate_movement = 2
	flags = NOREACT
	var/datum/mind/mind
	var/hand = null
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
	var/next_move = null
	var/nutrition = 400.0//Carbon
	var/lying
	var/nodamage = 0

	//Vars that should only be accessed via procs
	var/bruteloss = 0.0//Living
	var/fireloss = 0.0//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/tank/internal = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon
	var/obj/item/clothing/suit/cloth= null//Carbon
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


mob
	//	list/SightBlockersList = /list
	Climbing //Tells if you are currently ascending stairs or not

/mob/proc/get_active_hand()
	if (hand)
		return l_hand
	else
		return r_hand

/mob/proc/get_inactive_hand()
	if ( ! hand)
		return l_hand
	else
		return r_hand

/mob/proc/put_in_hand(var/obj/item/I)
	if(!I) return
	I.loc = src
	if (hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/mob/proc/put_in_inactive_hand(var/obj/item/I)
	I.loc = src
	if (!hand)
		l_hand = I
	else
		r_hand = I
	I.layer = 20

/mob/proc/equipped()
	if (hand)
		return l_hand
	else
		return r_hand
	return

/mob/proc/drop_item(var/atom/target)
	var/obj/item/W = equipped()

	if (W)
		if (client)
			client.screen -= W
		if (W)
			if(target)
				W.loc = target.loc
			else
				W.loc = loc
			W.dropped(src)
			u_equip(W)
			if (W)
				W.layer = initial(W.layer)
		var/turf/T = get_turf(loc)
		if (istype(T))
			T.Entered(W)
	return

/mob/proc/swap_hand()
	src.hand = !( src.hand )
	if(hand)
		LH.icon_state = "l_hand_a"
		RH.icon_state = "r_hand"
	else
		RH.icon_state = "r_hand_a"
		LH.icon_state = "l_hand"

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
	if(def_zone)
		def_area = parse_zone(defen_zone.name)

	usr << "\red <B>[src] атакован(а) [user] в [hit_area] с помощью [I.name] !</B>"
	usr << select_lang("\red <B>[src] атакован(а) [user] в [hit_area] с помощью [I.name] !</B>", "\red <B>[src] attacked [user] to [hit_area] by [I.name] !</B>")

	if((user != src))
		return 0

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
		screen_res = "1920x1080"

	proc/view_to_res()
		if(usr.client)
			switch(screen_res)
				if("640x480")
					usr.client.view = 4
				if("800x600")
					usr.client.view = 5
				if("1024x768")
					usr.client.view = 6
				if("1280x1024")
					usr.client.view = 7
				if("1920x1080")
					usr.client.view = 8

/mob
	var
		obj/hud/l_hand/LH
		obj/hud/r_hand/RH
		obj/hud/drop/DP
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL
		obj/hud/zone_sel_def/DF_ZONE
		obj/hud/cloth/CL
		//obj/hud/rose_of_winds/ROW
		obj/hud/hide_walls/HW
		obj/hud/act_intent/AC


	proc
		create_hud(var/client/C)
			LH = new(src)
			RH = new(src)
			DP = new(src)
			PULL = new(src)
			ZN_SEL = new(src)
			CL = new(src)
			AC = new(src)
			//ROW = new(src)
			HW = new(src)
			DF_ZONE = new(src)

			C.screen.Add(LH)
			C.screen.Add(RH)
			C.screen.Add(DP)
			C.screen.Add(PULL)
			C.screen.Add(ZN_SEL)
			C.screen.Add(CL)
			//C.screen.Add(ROW)
			C.screen.Add(HW)
			C.screen.Add(AC)
			C.screen.Add(DF_ZONE)

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

	verb/who()
		set name = "Who"
		set category = "OOC"
		usr << usr.select_lang("игроки в игре: ", "players in game: ")
		for(var/mob/M in world)
			if(M.client)
				usr << M.ckey

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

	proc/switch_intent()
		if(intent)
			intent = 0
			return
		else
			intent = 1
			return

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
		if(chest.brute_dam > 80)
			reagents.remove_reagent("blood", 20)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, епта
			BD = new(src.loc)

		if(head.brute_dam > 80)
			reagents.remove_reagent("blood", 18)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, епта
			BD = new(src.loc)

		if(r_leg.brute_dam > 80)
			reagents.remove_reagent("blood", 14)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, епта
			BD = new(src.loc)

		if(l_leg.brute_dam > 80)
			reagents.remove_reagent("blood", 14)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, епта
			BD = new(src.loc)

		if(r_arm.brute_dam > 80)
			reagents.remove_reagent("blood", 8)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, епта
			BD = new(src.loc)

		if(l_arm.brute_dam > 80)
			reagents.remove_reagent("blood", 8)
			src << select_lang("\red Вы тер&#255;ете немного крови", "You have blood loss") //Хуй знает как еще перевести! Соре, еп
			BD = new(src.loc)

		if(!reagents.has_reagent("blood", 50))
			death()

		if(BD)
			BD.pixel_z = (ZLevel - 1) * 32

	proc/stop_pulling()
		pulling.pullers -= src
		pulling = null
		PULL.icon_state = "pull_1"

	proc/update_pulling()
		if((get_dist(src, pulling) > 1) || !isturf(pulling.loc))
			stop_pulling()

	proc/Life()
		if(death == 0)
			set invisibility = 0
			set background = 1
			handle_stomach()
			handle_injury()
			handle_chemicals_in_body()

	proc/death(gibbed)
		src << select_lang("\red Ты умер. Пам-пам", "\red You are dead")
		death = 1
		rest()
		var/mob/ghost/zhmur = new(loc)
		zhmur.client = client
		return

	verb/suicide()
		set name = "Suicide"
		set category = "IC"
		death()

	attack_hand()
		if(death == 0 && !istype(src, /mob/ghost))
			if(usr.intent == 0) //harm

				var/datum/organ/external/defen_zone
				if(client)
					defen_zone = get_organ(ran_zone(src.DF_ZONE.selecting))

				var/datum/organ/external/affecting = get_organ(ran_zone(usr.ZN_SEL.selecting))
				if(defen_zone)
					if(defen_zone == affecting )
						src << select_lang("\red Вы блокируете часть урона", "\red You block damage partially")
						usr << usr.select_lang("\red [src] блокирует часть урона!", "\red [src] block damage partially")
						apply_damage(rand(6, 12) - defense, "brute" , affecting, 0)
				else
					apply_damage(rand(6, 12), "brute" , affecting, 0)
				for(var/mob/M in range(5, src))
					//M << "\red [usr] бьет [src] в область [affecting]"
					M << M.select_lang("\red [usr] бьет [src] в область [affecting]", "\red [usr] punch [src] to [affecting]")
			else
				return

	Move()
		if(lying)
			return
		see_invisible = 16 * (ZLevel-1)
		var/turf/wall_east = get_step(src, EAST)
		var/turf/wall_south = get_step(src, SOUTH)

		for(var/turf/simulated/floor/roof/RF in oview())
			RF.hide(usr)

		if(ZLevel == 2)
			for(var/turf/simulated/floor/roof/RF in oview())
				RF.show(usr)

		if(usr && usr.client)
			if(usr.client.dir == NORTH)
				if(dir == 2)
					wall_east = locate(usr.x + 1, usr.y - 1, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x + 1, usr.y, usr.z)

			if(usr.client.dir == EAST)
				if(dir == 2)
					wall_east = locate(usr.x - 1, usr.y - 1, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x - 1, usr.y, usr.z)

			if(usr.client.dir == SOUTH)
				if(dir == 2)
					wall_east = locate(usr.x - 1, usr.y, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x - 1, usr.y + 1, usr.z)

			if(usr.client.dir == WEST)
				if(dir == 2)
					wall_east = locate(usr.x + 1, usr.y, usr.z)

				if(dir == 1)
					wall_east = locate(usr.x + 1, usr.y + 1, usr.z)

		for(var/turf/simulated/wall/W in range(2, src))
			W.clear_for_all()

		if(wall_east && istype(wall_east, /turf/simulated/wall))
			var/turf/simulated/wall/my_wall = wall_east
			my_wall.hide_me()

		if(wall_south && istype(wall_south, /turf/simulated/wall))
			var/turf/simulated/wall/my_wall = wall_south
			my_wall.hide_me()

		if(!istype(loc, /turf/simulated/floor/stairs))
			pixel_z = (ZLevel-1) * 32

		var/oldloc = src.loc
		..()

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

/mob/proc/u_equip(obj/item/W as obj)
	if (W == r_hand)
		r_hand = null

	else if (W == l_hand)
		l_hand = null

	else if (W == cloth)
		cloth = null

/atom/movable/verb/pull()
	set name = "Pull"
	set src in oview(1)
	set category = "Local"
	if(usr.pulling == src)
		usr.stop_pulling()
		return
	if(usr.pulling)
		usr.stop_pulling()
	src.pullers += usr
	usr.pulling = src
	usr.PULL.icon_state = "pull_2"
	usr.update_pulling()

/atom/movable/proc/throw_hyuow_at(atom/target, range, speed)
	if(!target)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throw_hyuowing = 1

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y
		while(((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throw_hyuowing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw_hyuow range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
	else
		var/error = dist_y/2 - dist_x
		while(src && target &&((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throw_hyuowing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw_hyuow range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				//hit_check()
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)

	//done throw_hyuowing, either because it hit something or it finished moving
	src.throw_hyuowing = 0

/mob
	var/obj/lobby/lobby
	var/lobby_text
	var/sound/lobbysound = sound('sound/soviet_hymn.it')


	proc/create_lobby(var/client/C)
		C.screen += lobby

/mob/New()
	..()
	Move(pick(landmarks))

/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
	<head><title>[usr.select_lang("Приемный пункт","Start game")]</title></head> \
	<body style=\"font-family: Georgia, sans-serif;\"> \
	<a href='?src=\ref[src];display=show'>[usr.select_lang("Разрешение","Screen resolution")]</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];gender=male'>Male</a>\
	<br> \
	<a href='?src=\ref[src];gender=female'>Female</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];hair=new'>Hair</a>\
	<br> \
	<br> \
	<br> \
	<a href='?src=\ref[src];lang=eng'>ENG</a>\
	<br> \
	<a href='?src=\ref[src];lang=rus'>RUS</a>\
	<br> \
	<br> \
	<a href='?src=\ref[src];enter=yes'>[usr.select_lang("Вход","Join")]</a>\
	<br> \
	<a href='?src=\ref[src];enter=nahoy'>[usr.select_lang("Выход","Exit")]</a> \
	</body></html>"
	usr << browse(lobby_text,"window=setup")

/mob/Login()
	..()
	usr << "<h1>Приветствую вас на тестовом запуске изометрической станции. Здесь вы можете ознакомитьс&#255; с текущими особенност&#255;ми и возможност&#255;ми данного проекта</h1>"
	usr << "<h1><b>Врем&#255; мен&#255;ть станцию. И спасибо за внимание.</b></h2>"
	usr << "<h2><a href=\"https://discord.gg/2VyzxfE\">Багрепорты слать сюда. Здесь можно присоединитьс&#255; к обсуждению.</h2>"
	usr << "<h2><a href=\"https://sites.google.com/view/space-station-13-isometric\">Первый сайт проекта</h2>"
	usr << "<h2><a href=\"https://plinhost.github.io/Aurora_the_cruiser\">Второй сайт проекта</h2>"
	usr << "<h2><a href=\"https://github.com/Derven/Aurora_the_cruiser\">Репозиторий</h2>"
	lobby = new(usr)
	create_hud(usr.client)
	create_lobby(usr.client)
	usr << lobbysound
	show_lobby()

/mob/proc/resting()
	if(!lying)
		src.transform = turn(src.transform, 90)
		lying = 1
		density = 0
		return
	else
		if(death == 0)
			src.transform = turn(src.transform, -90)
			density = 1
			lying = 0
			return

/mob/verb/rest()
	set name = "Rest"
	set category = "IC"
	resting()

/mob/verb/miracle()
	set name = "Miracle"
	set category = "IC"
	death = 0
	reagents.add_reagent("blood", 200)
	heal_brute(80)

/mob/ghost
	invisibility = 100
	alpha = 128
	see_invisible = 101
	density = 0
	death = 1

/mob/verb/Say(msg as text)
	set name = "Say"
	set category = "IC"
	if(!findtext(msg," ",1,2) && msg)
		overlays.Add(overlay_cur)
		for(var/mob/M in range(5, src))
			if(death == 0)
				M << M.select_lang("[src] говорит, \"[fix255(msg)]\"", "[src] says, \"[fix255(msg)]\"")
		sleep(8)
		overlays.Remove(overlay_cur)

/mob/verb/Emote(msg as text)
	set name = "Emote"
	set category = "IC"
	for(var/mob/M in range(5, src))
		if(msg)
			if(!findtext(msg," ",1,2))
				M << "<b>[src] [fix255(msg)]</b>"

/mob/verb/OOC(msg as text)
	set name = "OOC"
	set category = "OOC"
	if(msg)
		if(!findtext(msg," ",1,2))
			world << "\blue OOC [usr.ckey]: [fix255(msg)]"

//mob/var/atom/cur_object_i_give
mob/var/atom/cur_object_i_see

mob/Stat()
	for(var/M in visible_containers)
		if(cur_object_i_see)
			if(M == cur_object_i_see.type)
				if(!istype(cur_object_i_see, /mob) && cur_object_i_see && cur_object_i_see.contents.len > 0) statpanel("contents", cur_object_i_see.contents)
				sleep(rand(5,8))
	//if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)

/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		Move(pick(jobmarks))
		lobby.invisibility = 101
		usr << sound(null)
		usr << browse(null, "window=setup")
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
		hair.layer = layer + 1
		overlays.Add(hair)

	if(href_list["gender"] == "male")
		icon_state = "mob"
	if(href_list["gender"] == "female")
		icon_state = "mob_f"
	if(href_list["lang"] == "rus")
		language = RUS
	if(href_list["lang"] == "eng")
		language = ENG

/mob/proc/drop_item_v()
	if (stat == 0)
		drop_item()
	return
