/turf/simulated/wall/window
	name = "window"
	icon_state = "window"
	opacity = 0
	walltype = "window"
	robustness = 10

	showcase
		layer = 16
		robustness = 30

	shuttle
		merge()
			return

	examine()
		world << "[icon_state]"

	var/image/damage
	health = 100

	Del()
		..()
		for(var/atom/movable/AM in src)
			AM.ZLevel -= 1
			pixel_z = (ZLevel - 1) * 32

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
		if(health <= 0)
			ReplaceWithPlating()

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

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/screwdriver))
			if(usr.do_after(25))
				for(var/mob/M in range(5, src.loc))
					M.playsoundforme('Screwdriver.ogg')
				ReplaceWithPlating()
				new /obj/item/stack/glass(src)
		else
			health -= W.force
			for(var/mob/M in range(5, src))
				M.playsoundforme('Glasshit.ogg')
			usr << "\red You punch the glass with [W]"
			update_icon()
			if(istype(src, /turf/simulated/wall/window))
				if(health < 30)
					ReplaceWithPlating()
					//relativewall_neighbours()
					usr << "The glass is broken"
					//del(src)