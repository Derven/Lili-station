//client vars
//---------------------
/client/var/played = 0
/client/var/sound_volume = 45 //From 0 to 30
/client/var/mdown = 0
/client/var/mloc
/client/var/northwest = 0
/client/var/northeast = 0
/client/var/southwest = 0
/client/var/southeast = 0
/client/var/pgdn = 0
/client/var/moving45 = 0
/client/preload_rsc = 0
/client/var/north
/client/var/east
/client/var/south
/client/var/west
/client/var/leftclick
/client/var/movetomouse = 0
/client/var/turf/TLOC = null

//client procs
//---------------------
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

client/verb/NorthReleased()
	set hidden = 1
	north = 0
	if(moving45 != 0)
		northeast = 0

client/verb/EastReleased()
	set hidden = 1
	east = 0
	if(moving45 != 0)
		southeast = 0

client/verb/SouthReleased()
	set hidden = 1
	south = 0
	if(moving45 != 0)
		southwest = 0

client/verb/WestReleased()
	set hidden = 1
	west = 0
	if(moving45 != 0)
		northwest = 0

client/verb/MLCP()
	set hidden = 1
	leftclick = 1

client/verb/MLCR()
	set hidden = 1
	leftclick = 0

client/MouseDown(var/atom/O, var/turf/T, control,params)
	for(var/obj/structure/table/TABLE in T)
		if(get_dist(T, mob) < 2)
			return
	if(mob:throwing_mode == 1)
		return
	if(!istype(mob, /mob/ghost) && istype(mob, /mob/simulated/living))
		var/mob/simulated/living/humanoid/H = mob
		var/obj/item/I = H.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			if(!I:load_into_chamber())
				return
			mdown = 1
			mloc = T
			var/obj/item/weapon/gun/G = I
			if(G.automatic == 1)
				sleep(1)
				while(mdown == 1)
					sleep(1)
					I.afterattack(mloc)
					if(!I:load_into_chamber())
						return
			else
				I.afterattack(mloc)
	..()

/client/North()
	north = 1
	if(moving45 == 0)
		if(west)
			Northwest()
			return
		if(east)
			Northeast()
			return
	else
		Northeast()
	..()

/client/South()
	south = 1
	if(moving45 == 0)
		if(west)
			Southwest()
			return
		if(east)
			Southeast()
			return
	else
		Southwest()
	..()

/client/West()
	west = 1
	if(moving45 == 0)
		if(north)
			Northwest()
			return
		if(south)
			Southwest()
			return
	else
		Northwest()
	..()

/client/East()
	east = 1
	if(moving45 == 0)
		if(north)
			Northeast()
			return
		if(south)
			Southeast()
			return
	else
		Southeast()
	..()

/client/Southwest()
	southwest = 1
	if(northwest)
		if(west == 0)
			West()
		return
	if(southeast)
		if(south == 0)
			South()
		return
	..()

/client/Southeast()
	southeast = 1
	if(northeast)
		if(east == 0)
			East()
		return
	if(southwest)
		if(south == 0)
			South()
		return
	..()

/client/Northwest()
	northwest = 1
	if(northeast)
		if(north == 0)
			North()
		return
	if(southwest)
		if(west == 0)
			West()
		return
	..()

/client/Northeast()
	northeast = 1
	if(northwest)
		if(north == 0)
			North()
		return
	if(southeast)
		if(east == 0)
			East()
		return
	..()

/client/MouseMove(var/turf/T)
	mloc = T
	..()

/client/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	var/atom/A = over_location
	if(istype(A, /turf))
		TLOC = A
		if(istype(mob, /mob/simulated/living/humanoid))
			var/list/myparapams = params2list(params)
			for(var/param in myparapams)
				if(param == "right")
					if(mob:middle_move_right_objects == 1)
						var/image/movingimage = image('floors.dmi',TLOC,"movement_overlay",15)
						var/movelag = 0
						if(istype(mob, /mob/simulated/living/humanoid))
							var/hungryeffect = 0
							if(mob && mob:nutrition < 150)
								hungryeffect = 1
							var/area/A2 = mob:loc.loc
							var/gravity = A2.gravitypower
							var/sleepy = mob:client:run_intent - round(mob:heart.pumppower/100) + hungryeffect + gravity
							movelag += sleepy
						mob << movingimage
						spawn(3)
							del(movingimage)
						if(get_dist(TLOC, mob) <= 1)
							for(var/obj/machinery/airlock/AIRLOCK in TLOC)
								AIRLOCK.attack_hand(mob)
						walk_to(mob,TLOC,0,movelag,64)
				if(param == "middle")
					if(mob:middle_move_right_objects == 0)
						var/image/movingimage = image('floors.dmi',TLOC,"movement_overlay",15)
						var/movelag = 0
						if(istype(mob, /mob/simulated/living/humanoid))
							var/hungryeffect = 0
							if(mob && mob:nutrition < 150)
								hungryeffect = 1
							var/area/A2 = mob:loc.loc
							var/gravity = A2.gravitypower
							var/sleepy = mob:client:run_intent - round(mob:heart.pumppower/100) + hungryeffect + gravity
							movelag += sleepy
						mob << movingimage
						spawn(3)
							del(movingimage)
						if(get_dist(TLOC, mob) <= 1)
							for(var/obj/machinery/airlock/AIRLOCK in TLOC)
								AIRLOCK.attack_hand(mob)
						walk_to(mob,TLOC,0,movelag,64)

	else if(istype(A, /area))
		return
	else
		if(A && A.loc)
			mloc = A.loc
	..()

/client/MouseUp()
	mdown = 0
	mob.client.movetomouse = 0