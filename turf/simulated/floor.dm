/turf/simulated/floor
	name = "floor"
	icon_state = "floor"
	luminosity = 0
	thermal_conductivity = 0.040
	heat_capacity = 10000
	intact = 0
	second_name = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WD = W
			if(WD.use())
				usr << "Вы развариваете пол..."
			else
				usr << "Заправьте горелку!"