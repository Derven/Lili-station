/turf/simulated/floor/plating

	robustness = 45

	ex_act()
		for(var/mob/M in range(2, src))
			M << 'Explosion2.ogg'
			if(rand(1, 100) < 100 - robustness)
				del(src)

	icon_state = "plating"
	pixel_z = -3

	Entered(var/atom/movable/O)
		O.pixel_z = -3

	Exited(var/atom/movable/O)
		O.pixel_z = 0

	proc/merge()
		var/turf/N = get_step(src, NORTH)
		var/turf/W = get_step(src, WEST)

		var/turf/S = get_step(src, SOUTH)
		var/turf/E = get_step(src, EAST)

		if(W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating) && E && istype(E, /turf/simulated/floor) && !istype(E, /turf/simulated/floor/plating))
			icon_state = "plating_we"
			return
		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating) && W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating))
			icon_state = "plating_nw"
			return
		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating) && S && istype(S, /turf/simulated/floor) && !istype(S, /turf/simulated/floor/plating))
			icon_state = "plating_sn"
			return
		if(S && istype(S, /turf/simulated/floor) && !istype(S, /turf/simulated/floor/plating) && E && istype(W, /turf/simulated/floor) && !istype(E, /turf/simulated/floor/plating))
			icon_state = "plating_se"
			return
		if(S && istype(S, /turf/simulated/floor) && !istype(S, /turf/simulated/floor/plating) && W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating))
			icon_state = "plating_sw"
			return
		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating) && E && istype(E, /turf/simulated/floor) && !istype(E, /turf/simulated/floor/plating))
			icon_state = "plating_ne"
			return
		if(N && istype(N, /turf/simulated/floor) && !istype(N, /turf/simulated/floor/plating))
			icon_state = "plating_n"
			return
		if(W && istype(W, /turf/simulated/floor) && !istype(W, /turf/simulated/floor/plating))
			icon_state = "plating_w"
			return
		if(S && istype(S, /turf/simulated/floor) && !istype(S, /turf/simulated/floor/plating))
			icon_state = "plating_s"
			return
		if(E && istype(E, /turf/simulated/floor) && !istype(E, /turf/simulated/floor/plating))
			icon_state = "plating_e"
			return

		else
			icon_state = "plating"