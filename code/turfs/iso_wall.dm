var
	Pixel_Height = 32

atom/var
	ZLevel = 1

proc/init_z_pixel()
	for(var/atom/movable/All as mob | obj in world) //This sets the initial height of the atoms in the world
		All.pixel_z = (All.ZLevel - 1) * 32

turf
	var
		SeeThrough //This binary variable shows whether or not a turf is currently see-through.
		Image //This variable is used to display the icon of the turf
		ImageType //This determines what the name of the icon's icon_state is
		Height = 1 //This variable tells how 'high' the wall is. A flat surface is 1.
	layer = 1

turf
	Enter(var/mob/A)
		if(A.ZLevel == src.Height) //If the player is not on the same Z plane as the turf, you can't enter it
			for(var/atom/movable/AM in src)
				if(AM.density == 1)
					return 0
			return 1

mob
	var
	//	list/SightBlockersList = /list
		Climbing //Tells if you are currently ascending stairs or not

/turf/simulated/floor/floorwall
	Height = 2
	density = 0
	icon_state = "floorwall"

/turf/simulated/floor/platingwall
	Height = 2
	density = 0
	pixel_z = -3

/turf/simulated/wall/stairs
	icon_state = "stairsnorth"
	density = 1
	Height = 2

	Enter(var/mob/A)
		A.ZLevel += 1
		spawn(1) A.pixel_z += Pixel_Height/8
		spawn(1) A.pixel_z += Pixel_Height/8
		spawn(2) A.pixel_z += Pixel_Height/4
		A.Climbing = 1
		return 1

	Exit(var/mob/A) //Checks when you exit if you are moving in an acceptable direction.
		if(A.dir == SOUTH)
			spawn(1) A.pixel_z -= Pixel_Height/8
			spawn(1) A.pixel_z -= Pixel_Height/8
			spawn(2) A.pixel_z -= Pixel_Height/4
			A.Climbing = 0
			A.ZLevel -= 1
			return 1
		else if(A.dir == NORTH)
			spawn(1) A.pixel_z += Pixel_Height/8
			spawn(1) A.pixel_z += Pixel_Height/8
			spawn(2) A.pixel_z += Pixel_Height/4
			A.Climbing = 0
			return 1

/turf/simulated/wall
	var/image/wall_overlay
	var/image/hide_wall

	up_wall

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
		//del(hide_wall) 10 оптимизаций из 10
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