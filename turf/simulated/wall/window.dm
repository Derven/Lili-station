/turf/simulated/wall/window
	name = "window"
	icon_state = "window"
	opacity = 0
	walltype = "window"

	var/image/damage
	var/health = 100

	update_icon()
		if(health > 80)
			return
		if(health > 60)
			damage = image("icon" = 'walls.dmi', "icon_state" = "damage_1")
		if(health > 30)
			damage = image("icon" = 'walls.dmi', "icon_state" = "damage_2")

		overlays += damage

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