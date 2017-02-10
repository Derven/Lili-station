/mob
	icon = 'mob.dmi'
	icon_state = "mob"
	layer = 15
	var/death = 0
	var/intent = 1 //1 - help, 0 - harm

	gender = MALE
	var/list/stomach_contents = list()

	var/brain_op_stage = 0.0
	var/eye_op_stage = 0.0
	var/appendix_op_stage = 0.0
	var/datum/organ/external/chest/chest
	var/datum/organ/external/head/head
	var/datum/organ/external/l_arm/l_arm
	var/datum/organ/external/r_arm/r_arm
	var/datum/organ/external/r_leg/r_leg
	var/datum/organ/external/l_leg/l_leg
	var/datum/organ/external/groin/groin
	//var/datum/disease2/disease/virus2 = null
	//var/list/datum/disease2/disease/resistances2 = list()
	var/antibodies = 0

	proc/handle_chemicals_in_body()
		if(reagents) reagents.metabolize(src)

	verb/who()
		for(var/mob/M in world)
			usr << "игроки в игре: "
			if(M.client)
				usr << M.ckey

	New()
		select_overlay = image(usr)
		usr.select_overlay.override = 1
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

		chest = new /datum/organ/external/chest(src)
		head = new /datum/organ/external/head(src)
		l_arm = new /datum/organ/external/l_arm(src)
		r_arm = new /datum/organ/external/r_arm(src)
		r_leg = new /datum/organ/external/r_leg(src)
		l_leg = new /datum/organ/external/l_leg(src)
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
		if(chest.brute_dam > 80)
			reagents.remove_reagent("blood", 20)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(head.brute_dam > 80)
			reagents.remove_reagent("blood", 18)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(r_leg.brute_dam > 80)
			reagents.remove_reagent("blood", 14)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(l_leg.brute_dam > 80)
			reagents.remove_reagent("blood", 14)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(r_arm.brute_dam > 80)
			reagents.remove_reagent("blood", 8)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(l_arm.brute_dam > 80)
			reagents.remove_reagent("blood", 8)
			src << "\red Вы тер&#255;ете немного крови"
			new /obj/blood (src.loc)

		if(!reagents.has_reagent("blood", 50))
			death()

	proc/update_pulling()
		if (!pulling)
			PULL.icon_state = "pull_1"
			return 0
		else
			PULL.icon_state = "pull_2"

	proc/Life()
		if(death == 0)
			set invisibility = 0
			set background = 1
			handle_stomach()
			handle_injury()
			handle_chemicals_in_body()

	proc/death(gibbed)
		timeofdeath = world.time
		world << "DEATH"
		death = 1
		rest()
		return

	attack_hand()
		if(death == 0)
			if(usr.intent == 0) //harm
				var/datum/organ/external/affecting = get_organ(ran_zone(usr.ZN_SEL.selecting))
				apply_damage(rand(5, 10), BRUTE , affecting, 0)
				for(var/mob/M in range(5, src))
					M << "\red [usr] бьет [src] в область [affecting]"
			else
				return

	Move()
		if(lying)
			return
		else
			if(src.pulling)
				step(src.pulling, get_dir(src.pulling.loc, usr))
			var/turf/wall_east = get_step(src, EAST)
			var/turf/wall_south = get_step(src, SOUTH)

			if(usr)
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

			..()

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
					if(istype(O, /datum/organ/external/r_leg))
						if(O.brute_dam + O.burn_dam > 60)
							if(prob(40))
								rest()
								src << "\red Вам очень больно! Права&#255; нога болит"
					if(istype(O, /datum/organ/external/l_leg))
						if(O.brute_dam + O.burn_dam > 60)
							if(prob(40))
								rest()
								src << "\red Вам очень больно! Левая&#255; нога болит"

					if(istype(O, /datum/organ/external/l_arm))
						if(O.brute_dam + O.burn_dam > 60)
							if(prob(40))
								if (hand)
									drop_item_v()
								else
									swap_hand()
									drop_item_v()
								src << "\red Вам очень больно! Лева&#255; рука болит"

					if(istype(O, /datum/organ/external/r_arm))
						if(O.brute_dam + O.burn_dam > 60)
							if(prob(40))
								if (!hand)
									drop_item_v()
								else
									swap_hand()
									drop_item_v()
								src << "\red Вам очень больно! Права&#255; рука болит"

/atom/proc/relaymove()
	return

/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera)
		return
	spawn(1)
		var/oldeye=M.client.eye
		var/x
		M.shakecamera = 1
		for(x=0; x<duration, x++)
			M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		M.shakecamera = 0
		M.client.eye=oldeye

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

	if(usr.pulling != src)
		if (!( usr ))
			return

		if(src.loc == usr)
			return

		if (!( src.anchored ))
			usr.pulling = src
			//Wire: Hi this was so dumb. Turns out it isn't only humans that have huds, who woulda thunk!!
			if (usr && usr.PULL) //yes this uses the dreaded ":", deal with it
				usr.update_pulling()
		return
	else
		usr.pulling = null
		usr.update_pulling()
		return

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
