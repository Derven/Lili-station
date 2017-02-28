/turf/simulated/floor
	name = "floor"
	icon_state = "floor"
	luminosity = 0
	thermal_conductivity = 0.040
	heat_capacity = 10000
	intact = 0


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
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WD = W
			if(WD.use())
				usr << "Вы развариваете пол..."
			else
				usr << "Заправьте горелку!"