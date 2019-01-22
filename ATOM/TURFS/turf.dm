#define DEBUG 1

/turf
	icon = 'floors.dmi'
	var/intact = 1 //for floors, use is_plating(), is_steel_floor() and is_light_floor()
	level = 1.0

	var
		//Properties for open tiles (/floor)
		oxygen = 0
		carbon_dioxide = 0
		nitrogen = 0
		toxins = 0

		//Properties for airtight tiles (/wall)
		thermal_conductivity = 0.05
		heat_capacity = 1

		//Properties for both
		temperature = 0

		blocks_air = 0
		icon_old = null
		pathweight = 1

	proc/is_plating()
		return 0
	proc/is_asteroid_floor()
		return 0
	proc/is_steel_floor()
		return 0
	proc/is_light_floor()
		return 0
	proc/is_grass_floor()
		return 0
	proc/return_siding_icon_state()
		return 0

	attack_hand()
		if(usr.mycraft_atom)
			if(istype(usr.mycraft_atom, /turf))
				src = new usr.mycraft_atom.type(src)
				for(var/turf/simulated/wall/W in range(1,src))
					W.merge()
			else
				var/atom/A = new usr.mycraft_atom.type(src)
				if(istype(A, /obj))
					var/obj/O = A
					START_PROCESSING(SSobj, O)
				A.dir = usr.mycraft_atom.dir
			usr << "\blue You build [usr.mycraft_atom]"
			usr.mycraft_atom = null
			usr.client.images -= usr.mycraft
			usr.mycraft = null

			if(istype(usr, /mob/simulated/living/humanoid))
				var/mob/simulated/living/humanoid/H = usr
				H.CRFT.invisibility = 101

/turf/proc/replace_turf()
	for(var/turf/T in locate(x,y,z+1))
		T = src

turf
	var
		SeeThrough //This binary variable shows whether or not a turf is currently see-through.
		Image //This variable is used to display the icon of the turf
		ImageType //This determines what the name of the icon's icon_state is
		Height = 1 //This variable tells how 'high' the wall is. A flat surface is 1.
	layer = 1

turf
	Enter(var/mob/A)
		if(istype(A, /mob/ghost))
			return 1

		if(A.ZLevel == src.Height) //If the player is not on the same Z plane as the turf, you can't enter it
			for(var/atom/movable/AM in src)
				if(AM.density == 1 && AM.ZLevel == A.ZLevel)
					return 0
			return 1
		if(A.ZLevel > src.Height)
			A.ZLevel = Height
			A.pixel_z = 32 * (A.ZLevel - 1)
			for(var/mob/mob_fall in range(5, A))
				mob_fall << "\red [A.name] fall on the floor"
				mob_fall.playsoundforme('smash.ogg')
			return 1

		if(istype(src, /turf/simulated/floor/roof))
			for(var/atom/movable/AM in src)
				if(AM.density == 1 && AM.ZLevel == A.ZLevel)
					A.invisibility = 15 * (A.ZLevel-1)
					return 0
			return 1
