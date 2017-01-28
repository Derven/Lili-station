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

		var/total_moles = environment.total_moles()
		var/pressure = environment.return_pressure()
		var/o2_level

		//space runtime fix
		if(total_moles != 0)
			o2_level = environment.oxygen/total_moles
		else
			o2_level = 0

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

	floor_down
		pixel_z = -64

/turf/simulated/floor/plating
	icon_state = "plating"
	pixel_z = -3

	attack_hand()
		replace_turf()

	proc/merge()
		var/turf/N = get_step(src, NORTH)
		var/turf/W = get_step(src, WEST)

		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating) && W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating))
			icon_state = "plating_nw"
			return
		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating))
			icon_state = "plating_n"
			return
		if(W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating))
			icon_state = "plating_w"
			return
		else
			icon_state = "plating"

/turf/ship
	name = "floor"
	icon_state = "ship"
	oxygen = 0
	nitrogen = 0

	New()
		..()
		generate_ship()

	proc/generate_ship()
		icon_state = "[icon_state]_[rand(1,8)]"

/turf/proc/replace_turf()
	for(var/turf/T in locate(x,y,z+1))
		T = src

/turf/simulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "wall"
	density = 1
	blocks_air = 1
	opacity = 1
	var/walltype = "wall"

	New()
		..()
		hide_wall = image('walls.dmi', icon_state = "wall_hide", layer = 10, loc = src)
		hide_wall.override = 1
		merge()
		//relativewall_neighbours()
		if(!istype(src, /turf/simulated/wall/window))
			if(prob(30))
				var/rand_num = rand(1,2)
				overlays += image(icon = 'walls.dmi', icon_state = "overlay_[rand_num]")

	Del()
		..()
		//relativewall_neighbours()

/turf/simulated/wall/window
	name = "window"
	icon_state = "window"
	opacity = 0
	walltype = "window"

	var/image/damage
	var/health = 100

	New()
		..()
		merge()

	update_icon()
		if(health > 80)
			return
		if(health > 60)
			damage = image("icon" = 'walls.dmi', "icon_state" = "damage_1")
		if(health > 30)
			damage = image("icon" = 'walls.dmi', "icon_state" = "damage_2")

		overlays += damage

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		health -= W.force
		brat << "Вы бьете стекло и оно трещит от ваших ударов"
		update_icon()
		if(health < 30)
			src = new /turf/simulated/floor/plating(src)
			//relativewall_neighbours()
			brat << "<b>Стекло разбиваетс&#255;</b>"
			//del(src)

	merge()
		var/turf/N = get_step(src, NORTH)
		var/turf/S = get_step(src, SOUTH)
		var/turf/W = get_step(src, WEST)
		var/turf/E = get_step(src, EAST)

		if(N && istype(N, /turf/simulated/wall/window))
			icon_state = "window_n"
			if(S && istype(S, /turf/simulated/wall/window))
				icon_state = "window_ns"
			if(W && istype(W, /turf/simulated/wall/window))
				icon_state = "window_nw"
			if(E && istype(E, /turf/simulated/wall/window))
				icon_state = "window_ne"

		if(S && istype(S, /turf/simulated/wall/window))
			icon_state = "window_s"
			if(N && istype(N, /turf/simulated/wall/window))
				icon_state = "window_ns"
			if(W && istype(W, /turf/simulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/simulated/wall/window))
				icon_state = "window_se"

		if(W && istype(W, /turf/simulated/wall/window))
			icon_state = "window_w"
			if(N && istype(N, /turf/simulated/wall/window))
				icon_state = "window_nw"
			if(S && istype(S, /turf/simulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/simulated/wall/window))
				icon_state = "window_we"

		if(E && istype(E, /turf/simulated/wall/window))
			icon_state = "window_w"
			if(N && istype(N, /turf/simulated/wall/window))
				icon_state = "window_nw"
			if(S && istype(S, /turf/simulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/simulated/wall/window))
				icon_state = "window_we"

/turf/unsimulated/floor
	name = "floor"
	icon_state = "floor"

	planet
		icon_state = "sand"

/obj
	station_base
		icon = 'floors.dmi'
		name = "floor"
		icon_state = "floor"
		density = 0
		invisibility = 101

		wall
			icon_state = "wall"


/turf/space
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"
	layer = 0.5

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/space/New()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/proc/ReplaceWithSpace()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	return S