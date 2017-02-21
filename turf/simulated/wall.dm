/turf/simulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "wall"
	Height = 2
	density = 1
	blocks_air = 1
	opacity = 1
	var/walltype = "wall"
	second_name = 1

	New()
		..()
		hide_wall = image('walls.dmi', icon_state = "[src.icon_state]_hide", layer = 10, loc = src)
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

/turf/simulated/wall
	var/image/wall_overlay
	var/image/hide_wall

	attack_hand()
		merge()

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
			..()

	proc/clear_images()
		usr.client.images -= hide_wall

	proc/clear_for_all()
		for(var/mob/M in view(5, usr))
			if(M.client && !istype(src, /turf/simulated/wall/window))
				M.client.images -= hide_wall

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
				if(S && istype(S, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_s", layer = 10)
					overlays.Add(wall_overlay)
				if(W && istype(W, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_w", layer = 10)
					overlays.Add(wall_overlay)
				if(E && istype(E, /turf/simulated/wall))
					wall_overlay = image('walls.dmi', icon_state = "overlay_e", layer = 10)
					overlays.Add(wall_overlay)