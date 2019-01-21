/turf/simulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "wall"
	Height = 3
	density = 1
	opacity = 1
	blocks_air = 1
	var/health = 10000
	var/walltype = "wall"
		//Properties for airtight tiles (/wall)
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall
	temperature = T20C
	robustness = 65
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	CanPass()
		return !density


	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.firer != src)
			if(istype(Proj, /obj/item/projectile/beam/explosive))
				boom(rand(1,2), src)
			else
				new /obj/effect/sparks(src)
			del(Proj)
		return 0

	ex_act()
		for(var/mob/M in range(2, src))
			M.playsoundforme('Explosion2.ogg')
		if(rand(1, 100) < 100 - robustness)
			ReplaceWithPlating()

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/W = O
			if(W.reagents.has_reagent("diesel", 10))
				if(usr.do_after(45))
					W.use()
					flick("active", W)
					new /obj/item/stack/metal(src)
					clear_for_all()
					ReplaceWithPlating()
			else
				usr << "\red Oh no! Need more fuel!"
				return
	New()
		..()
		hide_wall = image('walls.dmi', icon_state = "[src.icon_state]_hide", layer = 10, loc = src)
		hide_wall.override = 1
		if(prob(5))
			icon_state = "wall[rand(1,6)]"
		merge()
		//relativewall_neighbours()
		if(!istype(src, /turf/simulated/wall/window))
			if(prob(30))
				var/rand_num = rand(1,2)
				overlays += image(icon = 'walls.dmi', icon_state = "overlay_[rand_num]")

		for(var/turf/T in locate(x,y,z))
			if(istype(T, /turf/space))
				del(T)

	Del()
		..()
		//relativewall_neighbours()

	//verb/light_capacity()
	//	set src in range(1, usr)
	//	world << lightcapacity

/turf/simulated/wall
	var/image/wall_overlay
	var/image/hide_wall
	var/newicon

	//MouseEntered()
	//	hide_me()

	verb/hide()
		set name = "Hide"
		set category = null
		set src in view(usr)
		usr << hide_wall
		sleep(25)
		usr.client.images -= hide_wall
		//del(hide_wall) 10 оптимизаций из 10
		merge()

	proc/hide_me()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				M << hide_wall
				merge()
				if(newicon)
					icon_state = newicon
			..()

	proc/clear_images()
		usr.client.images -= hide_wall

	proc/clear_for_all()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				M.client.images -= hide_wall
				if(newicon)
					icon_state = newicon

	proc/merge()
		if(!istype(src, /turf/simulated/wall/asteroid))
			if(!istype(src, /turf/simulated/wall/window))
				overlays.Cut()
				var/turf/N = get_step(src, NORTH)
				var/turf/S = get_step(src, SOUTH)
				var/turf/W = get_step(src, WEST)
				var/turf/E = get_step(src, EAST)

				if(N && istype(N, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_n", layer = 10)
					overlays.Add(wall_overlay)
				if(W && istype(W, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_w", layer = 10)
					overlays.Add(wall_overlay)
				if(S && istype(S, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_s", layer = 10)
					overlays.Add(wall_overlay)
				if(E && istype(E, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_e", layer = 10)
					overlays.Add(wall_overlay)

/turf/simulated/wall/out
	icon_state = "out"

	merge()
		return