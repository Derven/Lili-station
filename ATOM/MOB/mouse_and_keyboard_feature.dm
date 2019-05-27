client
	var/mdown = 0
	var/mloc

client/MouseDown(var/atom/O, var/turf/T)
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


client/MouseMove(var/turf/T)
	mloc = T
	..()

client/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	var/atom/A = src_location
	if(istype(A, /turf))
		mloc = A
	else if(istype(A, /area))
		return
	else
		if(A && A.loc)
			mloc = A.loc
	..()

client/MouseUp()
	mdown = 0

/client
	var/northwest = 0
	var/northeast = 0
	var/southwest = 0
	var/southeast = 0
	var/pgdn = 0
	var/moving45 = 0


	North()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_n", H.M)

	South()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_s", H.M)

	West()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_w", H.M)

	East()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_e", H.M)

	Southwest()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_sw", H.M)

	Southeast()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_se", H.M)

	Northwest()
		var/mob/simulated/living/humanoid/H = mob
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
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_nw", H.M)

	Northeast()
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
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_ne", H.M)


client
	var
		north
		east
		south
		west
		leftclick
	verb
		NorthReleased()
			set hidden = 1
			north = 0
			if(moving45 != 0)
				northeast = 0

		EastReleased()
			set hidden = 1
			east = 0
			if(moving45 != 0)
				southeast = 0

		SouthReleased()
			set hidden = 1
			south = 0
			if(moving45 != 0)
				southwest = 0

		WestReleased()
			set hidden = 1
			west = 0
			if(moving45 != 0)
				northwest = 0
		MLCP()
			set hidden = 1
			leftclick = 1
		MLCR()
			set hidden = 1
			leftclick = 0