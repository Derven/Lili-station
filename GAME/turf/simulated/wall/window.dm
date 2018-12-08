/turf/unsimulated/wall/window
	name = "window"
	icon_state = "window"
	opacity = 0
	walltype = "window"
	robustness = 10

	shuttle
		merge()
			return

	examine()
		world << "[icon_state]"

	var/image/damage
	var/health = 100

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
			src = new /turf/simulated/floor/plating(src)

	merge()
		var/turf/N = get_step(src, NORTH)
		var/turf/S = get_step(src, SOUTH)
		var/turf/W = get_step(src, WEST)
		var/turf/E = get_step(src, EAST)

		if(N && istype(N, /turf/unsimulated/wall/window))
			icon_state = "window_n"
			if(S && istype(S, /turf/unsimulated/wall/window))
				icon_state = "window_ns"
			if(W && istype(W, /turf/unsimulated/wall/window))
				icon_state = "window_nw"
			if(E && istype(E, /turf/unsimulated/wall/window))
				icon_state = "window_ne"

		if(S && istype(S, /turf/unsimulated/wall/window))
			icon_state = "window_s"
			if(N && istype(N, /turf/unsimulated/wall/window))
				icon_state = "window_ns"
			if(W && istype(W, /turf/unsimulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/unsimulated/wall/window))
				icon_state = "window_se"

		if(W && istype(W, /turf/unsimulated/wall/window))
			icon_state = "window_w"
			if(N && istype(N, /turf/unsimulated/wall/window))
				icon_state = "window_nw"
			if(S && istype(S, /turf/unsimulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/unsimulated/wall/window))
				icon_state = "window_we"

		if(E && istype(E, /turf/unsimulated/wall/window))
			icon_state = "window_w"
			if(N && istype(N, /turf/unsimulated/wall/window))
				icon_state = "window_nw"
			if(S && istype(S, /turf/unsimulated/wall/window))
				icon_state = "window_sw"
			if(E && istype(E, /turf/unsimulated/wall/window))
				icon_state = "window_we"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/screwdriver))
			for(var/mob/M in range(5, src.loc))
				M << 'Screwdriver.ogg'
			src = new /turf/simulated/floor/plating(src)
			new /obj/item/stack/glass(src)
		else
			health -= W.force
			usr << usr.select_lang("\red Вы бьете стекло с помощью [W]", "\red You punch the glass with [W]")
			update_icon()
			if(istype(src, /turf/unsimulated/wall/window))
				if(health < 30)
					src = new /turf/simulated/floor/plating(src)
					//relativewall_neighbours()
					usr << usr.select_lang("\red Стекло разбиваетс&#255;", "The glass is broken")
					//del(src)