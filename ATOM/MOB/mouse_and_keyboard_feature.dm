client
	var/mdown = 0
	var/mloc

client/MouseDown(var/atom/O, var/turf/T)
	mdown = 1
	mloc = T
	if(!istype(mob, /mob/ghost) && istype(mob, /mob/simulated/living))
		var/mob/simulated/living/humanoid/H = mob
		var/obj/item/I = H.get_active_hand()
		if(istype(I, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = I
			if(G.automatic == 1)
				sleep(1)
				while(mdown == 1)
					sleep(1)
					I.afterattack(mloc)
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
	North()
		north = 1
		if(west)
			Northwest()
			return
		if(east)
			Northeast()
			return
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_n", H.M)

	South()
		south = 1
		if(west)
			Southwest()
			return
		if(east)
			Southeast()
			return
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_s", H.M)

	West()
		west = 1
		if(north)
			Northwest()
			return
		if(south)
			Southwest()
			return
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_w", H.M)

	East()
		east = 1
		if(north)
			Northeast()
			return
		if(south)
			Southeast()
			return
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_e", H.M)

	Southwest()
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_sw", H.M)

	Southeast()
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_se", H.M)

	Northwest()
		..()
		var/mob/simulated/living/humanoid/H = mob
		if(istype(H, /mob/simulated/living/humanoid))
			flick("movement_nw", H.M)

	Northeast()
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
		EastReleased()
			set hidden = 1
			east = 0
		SouthReleased()
			set hidden = 1
			south = 0
		WestReleased()
			set hidden = 1
			west = 0
		MLCP()
			set hidden = 1
			leftclick = 1
		MLCR()
			set hidden = 1
			leftclick = 0