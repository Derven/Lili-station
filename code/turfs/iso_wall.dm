

/turf/simulated/wall
	var/image/wall_overlay
	var/image/hide_wall

	down_wall
		pixel_z = -64

	attack_hand()
		merge()

	verb/hide()
		set src in view(usr)
		hide_wall = image('walls.dmi', icon_state = "wall_hide", layer = 10, loc = src)
		hide_wall.override = 1
		usr << hide_wall
		overlays.Cut()
		sleep(25)
		del(hide_wall)
		merge()

	proc/hide_me()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				hide_wall = image('walls.dmi', icon_state = "wall_hide", layer = 10, loc = src)
				hide_wall.override = 1
				M << hide_wall
				overlays.Cut()
				merge()
			..()

	proc/clear_images()
		del(hide_wall)

	proc/merge()
		if(!istype(src, /turf/simulated/wall/window))
			overlays.Cut()
			var/turf/N = get_step(src, NORTH)
			var/turf/S = get_step(src, SOUTH)
			var/turf/W = get_step(src, WEST)
			var/turf/E = get_step(src, EAST)

			if(N && istype(N, /turf/simulated/wall))
				wall_overlay = image('walls.dmi', icon_state = "overlay_n", layer = 10)
				overlays.Add(wall_overlay)
			if(S && istype(S, /turf/simulated/wall))
				wall_overlay = image('walls.dmi', icon_state = "overlay_s", layer = 10)
				overlays.Add(wall_overlay)
			if(W && istype(W, /turf/simulated/wall))
				wall_overlay = image('walls.dmi', icon_state = "overlay_w", layer = 10)
				overlays.Add(wall_overlay)
			if(E && istype(E, /turf/simulated/wall))
				wall_overlay = image('walls.dmi', icon_state = "overlay_e", layer = 10)
				overlays.Add(wall_overlay)