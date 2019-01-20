/turf/simulated/wall/newicon
	var/w = "w"
	icon_state = "w"
	walltype = "w"

	proc/check_airlock(var/turf/iloc)
		if(locate(/obj/machinery/airlock, iloc))
			return 1
		else
			return 0


	merge()
		var/turf/N = get_step(src, NORTH)
		var/turf/S = get_step(src, SOUTH)
		var/turf/W = get_step(src, WEST)
		var/turf/E = get_step(src, EAST)

		if(S && E && W)
			if((istype(S, /turf/simulated/wall/newicon) || check_airlock(S)) && (istype(W, /turf/simulated/wall/newicon) || check_airlock(W)) && (istype(E, /turf/simulated/wall/newicon) || check_airlock(E)))
				icon_state = "[w]_ews"
				return

		if(N && E && S)
			if((istype(E, /turf/simulated/wall/newicon) || check_airlock(E)) && (istype(N, /turf/simulated/wall/newicon) || check_airlock(N)) && (istype(S, /turf/simulated/wall/newicon) ||check_airlock(S)))
				icon_state = "[w]_nse"
				return

		if(W && N && S)
			if((istype(W, /turf/simulated/wall/newicon) || check_airlock(W)) && (istype(N, /turf/simulated/wall/newicon) || check_airlock(N)) && (istype(S, /turf/simulated/wall/newicon) || check_airlock(S)))
				icon_state = "[w]_nsw"
				return

		if(N && E && W)
			if((istype(W, /turf/simulated/wall/newicon) || check_airlock(W)) && (istype(N, /turf/simulated/wall/newicon) || check_airlock(N)) && (istype(E, /turf/simulated/wall/newicon) || check_airlock(E)))
				icon_state = "[w]_ewn"
				return

		if(N && E)
			if((istype(E, /turf/simulated/wall/newicon) || check_airlock(E)) && (istype(N, /turf/simulated/wall/newicon) || check_airlock(N)))
				icon_state = "[w]_ne"
				return

		if(E && S)
			if((istype(E, /turf/simulated/wall/newicon) || check_airlock(E)) && (istype(S, /turf/simulated/wall/newicon) || check_airlock(S)))
				icon_state = "[w]_se"
				return

		if(W && N)
			if((istype(W, /turf/simulated/wall/newicon) || check_airlock(E)) && (istype(N, /turf/simulated/wall/newicon) || check_airlock(N)))
				icon_state = "[w]_wn"
				return

		if(S && W)
			if((istype(W, /turf/simulated/wall/newicon) || check_airlock(W)) && (istype(S, /turf/simulated/wall/newicon) || check_airlock(S)))
				icon_state = "[w]_sw"
				return

		if(E)
			if(istype(E, /turf/simulated/wall/newicon) || check_airlock(E))
				icon_state = "[w]_ew"
				return

		if(W)
			if(istype(W, /turf/simulated/wall/newicon) || check_airlock(W))
				icon_state = "[w]_ew"
				return

		if(N)
			if(istype(N, /turf/simulated/wall/newicon) || check_airlock(N))
				icon_state = "[w]_ns"
				return

		for(S)
			if(istype(S, /turf/simulated/wall/newicon) || check_airlock(S))
				icon_state = "[w]_ns"
				return

	window
		w = "window"
		icon_state = "w"
		opacity = 0
		health = 100

		attack_hand()
			if(newicon)
				if(istype(usr, /mob/simulated/living))
					var/mob/simulated/living/LVING = usr
					LVING << "You trying to climb over the broken glass"
					if(LVING.do_after(10))
						if(prob(15))
							LVING << "\red You hurt yourself on the broken glass"
							LVING.rand_damage(2, 5)
						LVING.x = x
						LVING.y = y
						LVING.z = z

		attackby(obj/item/weapon/W as obj, mob/user as mob)
			if(istype(W, /obj/item/weapon/screwdriver))
				if(usr.do_after(25))
					for(var/mob/M in range(5, src.loc))
						M.playsoundforme('Screwdriver.ogg')
					ReplaceWithPlating()
					new /obj/item/stack/glass(src)
			else
				if(health > 0)
					health -= W.force
					for(var/mob/M in range(5, src))
						M.playsoundforme('Glasshit.ogg')
					usr << "\red You punch the glass with [W]"
					update_icon()
					if(istype(src, /turf/simulated/wall/newicon/window))
						if(health < 1)
							if(!newicon)
								newicon = "[icon_state]_broken"
							//relativewall_neighbours()
							usr << "The glass is broken"
							icon_state = newicon
							density = 0
							//del(src)

		merge()
			var/turf/N = get_step(src, NORTH)
			var/turf/S = get_step(src, SOUTH)
			var/turf/W = get_step(src, WEST)
			var/turf/E = get_step(src, EAST)


			if(N && S)
				if(istype(N, /turf/simulated/wall/newicon/window) && istype(S, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_fullns"
					return

			if(E && W)
				if(istype(E, /turf/simulated/wall/newicon/window) && istype(W, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_fullwe"
					return

			if(E)
				if(istype(E, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_w2"
					return

			if(S)
				if(istype(S, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_s2"
					return

			if(W)
				if(istype(W, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_e2"
					return

			if(N)
				if(istype(N, /turf/simulated/wall/newicon/window))
					icon_state = "[w]_n2"
					return

			if(E && W)
				if(istype(E, /turf/simulated/wall/newicon) && istype(W, /turf/simulated/wall/newicon))
					icon_state = "[w]_ew"
					return

			if(N && S)
				if(istype(N, /turf/simulated/wall/newicon) && istype(S, /turf/simulated/wall/newicon))
					icon_state = "[w]_ns"
					return

			if(E)
				if(istype(E, /turf/simulated/wall/newicon))
					icon_state = "[w]_ew"
					return

			if(W)
				if(istype(W, /turf/simulated/wall/newicon))
					icon_state = "[w]_ew"
					return

			if(N)
				if(istype(N, /turf/simulated/wall/newicon))
					icon_state = "[w]_ns"
					return

			if(S)
				if(istype(S, /turf/simulated/wall/newicon))
					icon_state = "[w]_ns"
					return