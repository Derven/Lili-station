/turf/simulated/floor
	name = "floor"
	icon_state = "floor"
	luminosity = 0
	thermal_conductivity = 0.040
	heat_capacity = 10000
	intact = 0
	robustness = 25
	temperature = T20C - 23
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	ex_act()
		for(var/mob/M in range(2, src))
			M << 'Explosion2.ogg'

			if(rand(1, 100) < 100 - robustness)
				src = new /turf/simulated/floor/plating(src)

			if(rand(1, 100) < rand(1,5))
				del(src)

	verb/fall()
		set src in range(1, usr)
		if(Height < usr.ZLevel)
			for(var/mob/M in range(5, src))
				M << M.select_lang("\red [usr] падает на [src]", "\red [usr] falls onto [src]")
			usr.Move(src)
			usr.ZLevel = Height
			usr.layer = initial(usr.layer)
			usr.pixel_z = 32 * (usr.ZLevel - 1)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			for(var/mob/M in range(5, src.loc))
				M << 'Crowbar.ogg'
			src = new /turf/simulated/floor/plating(src)
			new /obj/item/stack/tile(src)