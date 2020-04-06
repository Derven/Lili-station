// It.. uses a lot of power.  Everything under power is engineering stuff, at least.
var/list/accessable_z_levels = list(1, 2)
/area
	var/gravitypower = 0

/area/proc/gravitychange(var/gravitystate = 0, var/area/A)

	A.has_gravity = gravitystate
	for(var/mob/simulated/living/humanoid/M in A)
		thunk(M)
	for(var/obj/O in A)
		if(istype(O.loc, /turf/simulated))
			if(O.anchored == 0 && O.density == 0)
				if(gravitystate == 0)
					O.pixel_z = rand(10, 23)
					O.transform = turn(O.transform, rand(15,125))
				else
					O.pixel_z = initial(O.pixel_z)
					O.transform = initial(O.transform)

/area/proc/thunk(mob)
	if(mob:client)
		if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
			return

		if((istype(mob,/mob/simulated/living/humanoid)) && (mob:client:run_intent == 2)) // Only clumbsy humans can fall on their asses.
			mob:weakened = 5
			mob:stunned = 5

		else if (istype(mob,/mob/simulated/living/humanoid))
			mob:weakened = 2
			mob:stunned = 2

		mob << "Gravity!"

/obj/machinery/computer/gravity_control_computer
	name = "Gravity Generator Control"
	desc = "A computer to control a local gravity generator.  Qualified personnel only."
	icon = 'stationobjs.dmi'
	icon_state = "consol"
	anchored = 1
	density = 1
	var/obj/machinery/gravity_generator = null


/obj/machinery/gravity_generator
	name = "Gravitational Generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'gravity.dmi'
	icon_state = "on"
	var/gravitypower = 0
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 1000
	plane = 80

	var/on = 1
	var/list/localareas = list()
	var/effectiverange = 25

	update_icon()

		if(on == 1)
			icon_state = "on"
		else
			icon_state = "off"

	proc/on_off()
		if(on)
			on = 0

			for(var/area/A in world)
				if(A.name != "Space")
					A.gravitychange(0,A)
		else
			for(var/area/A in world)
				if(A.name != "Space")
					on = 1
					A.gravitychange(1,A)

	process()
		if(on == 1)
			for(var/area/A in world)
				if(A.name != "Space")
					A.gravitypower = gravitypower
		else
			for(var/area/A in world)
				if(A.name != "Space")
					A.gravitypower = 0

	Del()
		..()
		for(var/area/A in world)
			if(A.name != "Space")
				A.gravitypower = 0
				A.gravitychange(0,A)

	// Borrows code from cloning computer
/obj/machinery/computer/gravity_control_computer/New()
	..()
	spawn(5)
		updatemodules()
		return
	return

/obj/machinery/computer/gravity_control_computer/proc/updatemodules()
	src.gravity_generator = findgenerator()

/obj/machinery/computer/gravity_control_computer/proc/findgenerator()
	var/obj/machinery/gravity_generator/foundgenerator = null
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		//world << "SEARCHING IN [dir]"
		foundgenerator = locate(/obj/machinery/gravity_generator/, get_step(src, dir))
		if (!isnull(foundgenerator))
			//world << "FOUND"
			break
	return foundgenerator


/obj/machinery/computer/gravity_control_computer/attack_hand(mob/user as mob)
	user.machine = src

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	var/dat = "<h3>Generator Control System</h3>"
	//dat += "<font size=-1><a href='byond://?src=\ref[src];refresh=1'>Refresh</a></font>"
	if(gravity_generator)
		if(gravity_generator:on)
			dat += "<font color=green><br><tt>Gravity Status: ON</tt></font><br>"
		else
			dat += "<font color=red><br><tt>Gravity Status: OFF</tt></font><br>"

		dat += "<br><tt>Currently Supplying Gravitons To:</tt><br>"

		for(var/area/A in world)
			if(A.name != "Space")
				if(A.has_gravity && gravity_generator:on)
					dat += "<tt><font color=green>[A]</tt></font><br>"

				else if (A.has_gravity)
					dat += "<tt><font color=yellow>[A]</tt></font><br>"

				else
					dat += "<tt><font color=red>[A]</tt></font><br>"

		dat += "<br><tt>Maintainence Functions:</tt><br>"
		if(gravity_generator:on)
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'><font color=red> TURN GRAVITY GENERATOR OFF. </font></a>"
		else
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'><font color=green> TURN GRAVITY GENERATOR ON. </font></a>"
		dat += "<br>GRAVITY POWER: <a href='byond://?src=\ref[src];powergr=1'><font color=green>1</font></a> <a href='byond://?src=\ref[src];powergr=2'><font color=green>2</font></a> <a href='byond://?src=\ref[src];powergr=3'><font color=green>3</font></a>"
	else
		dat += "No local gravity generator detected!"

	user << browse(dat, "window=gravgen")
	onclose(user, "gravgen")


/obj/machinery/computer/gravity_control_computer/Topic(href, href_list)
	set background = 1
	..()

	if ( (get_dist(src, usr) > 1 ))
		usr.machine = null
		usr << browse(null, "window=gravgen")
		return

	if(href_list["gentoggle"])
		if(gravity_generator:on)
			gravity_generator:on = 0

			for(var/area/A in world)
				if(A.name != "Space")
					A.gravitychange(0,A)
		else
			for(var/area/A in world)
				if(A.name != "Space")
					gravity_generator:on = 1
					A.gravitychange(1,A)
		gravity_generator:update_icon()
	if(href_list["powergr"] == "1")
		gravity_generator:gravitypower = 0
		world << "\blue Gravity power is 9,7"
		return
	if(href_list["powergr"] == "2")
		gravity_generator:gravitypower = 3
		world << "<b>Gravity power is 12,3</b>"
		return
	if(href_list["powergr"] == "3")
		gravity_generator:gravitypower = 5
		world << "\red Gravity power is 15,3"
		return

		return


/mob/proc/Process_Spacemove(var/check_drift = 0)
	//First check to see if we can do thing

	/*
	if(istype(src,/mob/living/carbon))
		if(src.l_hand && src.r_hand)
			return 0
	*/
	if(istype(src.loc, /turf))
		var/area/A = src.loc.loc
		var/dense_object = 0
		for(var/turf/turf in oview(1,src))
			if(istype(turf,/turf/space))
				continue

			if(istype(src,/mob/simulated/living/humanoid))  // Only humans can wear magboots, so we give them a chance to.
				if((istype(turf,/turf/simulated/floor)) && (A.has_gravity == 0))
					continue


			else
				if((istype(turf,/turf/simulated/floor)) && (A.has_gravity == 0)) // No one else gets a chance.
					continue



			/*
			if(istype(turf,/turf/simulated/floor) && (src.flags & NOGRAV))
				continue
			*/


			dense_object++
			break

		if(!dense_object in oview(1, src))
			dense_object++

		//Lastly attempt to locate any dense objects we could push off of
		//TODO: If we implement objects drifing in space this needs to really push them
		//Due to a few issues only anchored and dense objects will now work.
		if(!dense_object)
			for(var/obj/O in oview(1, src))
				if((O) && (O.density) && (O.anchored))
					dense_object++
					break

		//Nothing to push off of so end here
		if(!dense_object)
			return 0



	//Check to see if we slipped
	if(prob(Process_Spaceslipping(5)))
		src << "\blue <B>You slipped!</B>"
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 0
	//If not then we can reset inertia and move
	inertia_dir = 0
	return 1


/mob/proc/Process_Spaceslipping(var/prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)


/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/Entered(atom/movable/M as mob|obj)
	var/loopsanity = 100
	var/area/AR15 = M.loc.loc
	if(ismob(M))
		if(!AR15)
			AR15 = get_area(M.loc)
		if(AR15.has_gravity == 0)
			inertial_drift(M)
		else if(!istype(src, /turf/space))
			M:inertia_dir = 0
	..()
	var/objects = 0
	for(var/atom/A as mob|obj|turf|area in src)
		if(objects > loopsanity)	break
		objects++
	objects = 0
	for(var/atom/A as mob|obj|turf|area in range(1))
		if(objects > loopsanity)	break
		objects++
	if(objects == 0)
		inertial_drift(M)
	return


/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

	// Okay, so let's make it so that people can travel z levels but not nuke disks!
	// if(ticker.mode.name == "nuclear emergency")	return
	if (src.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE - 1) || src.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE - 1))
		var/move_to_z_str = pick(accessable_z_levels)

		var/move_to_z = text2num(move_to_z_str)

		if(!move_to_z)
			return

		A.z = move_to_z

		if(src.x <= TRANSITIONEDGE)
			A.x = world.maxx - TRANSITIONEDGE - 2

		else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
			A.x = TRANSITIONEDGE + 1

		else if (src.y <= TRANSITIONEDGE)
			A.y = world.maxy - TRANSITIONEDGE -2

		else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
			A.y = TRANSITIONEDGE +1

		spawn (0)
			if ((A && A.loc))
				A.loc.Entered(A)