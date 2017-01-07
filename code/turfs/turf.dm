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
		temperature = T20C

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

		var/datum/gas_mixture/environment = return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles()

		var/o2_level = environment.oxygen/total_moles

		world << "Давление: [round(pressure,0.1)] kPa"
		world << "Кислород: [round(o2_level*100)]%"

/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

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
				brat << "Вы развариваете пол..."
				if(do_after(brat, 5))
					if(z > 1)
						new /obj/glass/whore(src)
					else
						del(src)
			else
				brat << "Заправьте горелку!"

/turf/ship
	name = "floor"
	icon_state = "ship"
	oxygen = 0
	nitrogen = 0

/turf/simulated/wall
	name = "wall"
	icon_state = "wall"
	density = 1
	blocks_air = 1
	opacity = 1

/turf/simulated/wall/window
	name = "window"
	icon_state = "window"
	opacity = 0

/turf/unsimulated/floor
	name = "floor"
	icon_state = "floor"



/turf/space
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/proc/ReplaceWithSpace()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	return S