

/turf/simulated/wall
	var/image/wall_overlay
	var/image/hide_wall

	down_wall
		pixel_z = -64

	test
		icon_state = "test"

	attack_hand()
		merge()

	verb/hide()
		set src in view(usr)
		usr << hide_wall
		overlays.Cut()
		sleep(25)
		usr.client.images -= hide_wall
		//del(hide_wall) 10 ����������� �� 10
		merge()

	proc/hide_me()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				M << hide_wall
				overlays.Cut()
				merge()
			..()

	proc/clear_images()
		usr.client.images -= hide_wall

	proc/clear_for_all()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				M.client.images -= hide_wall

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