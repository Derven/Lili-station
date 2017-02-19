/turf/simulated/floor
	name = "floor"
	icon_state = "floor"
	luminosity = 0
	thermal_conductivity = 0.040
	heat_capacity = 10000
	intact = 0

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/cable_coil))
			var/obj/item/weapon/cable_coil/coil = W
			coil.turf_place(src, usr)

		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WD = W
			if(WD.use())
				usr << "Вы развариваете пол..."
			else
				usr << "Заправьте горелку!"

	floor_down
		pixel_z = -64