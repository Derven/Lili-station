/turf/simulated/floor/stairs
	icon_state = "stairsnorth"
	density = 1
	Height = 2


	Enter(var/atom/movable/A)
		..()
		if(A.x == src.x && (A.y + 1) == src.y && A.ZLevel == src.ZLevel)
			A.ZLevel += 1
			spawn(1) A.pixel_z += Pixel_Height/8
			spawn(1) A.pixel_z += Pixel_Height/8
			spawn(2) A.pixel_z += Pixel_Height/4
			A.Climbing = 1
			return 1

		else if(A.x == src.x && (A.y - 1) == src.y && (A.ZLevel - 1) == src.ZLevel)
			spawn(1) A.pixel_z -= Pixel_Height/8
			spawn(1) A.pixel_z -= Pixel_Height/8
			spawn(2) A.pixel_z -= Pixel_Height/4
			A.Climbing = 1
			return 1

		else
			return 0

	Exit(var/atom/movable/A) //Checks when you exit if you are moving in an acceptable direction.
		..()
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

		else
			return 0