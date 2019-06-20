// /obj/structure vars
//----------------------------
/obj/structure/robustness = 15
/obj/structure/var/pixelzheight = 16
/obj/structure/var/rotatable = 0
/obj/structure/var/climbcan = 0

// /obj/structure procs
//----------------------------
/obj/structure/CanPass(var/atom/A)
	if(istype(A, /mob))
		var/mob/M = A
		return M.onstructure
	return 0

/obj/structure/Uncrossed(var/mob/M)
	if(istype(M, /mob))
		for(var/obj/structure/S in M.loc)
			return
		leave(M)

/obj/structure/verb/rotate_me()
	set src in range(1)
	if(rotatable)
		dir = (turn(dir, 90))

/obj/structure/verb/climb_up()
	set src in range(1)
	if(climbcan == 1)
		if(usr.do_after(pixelzheight))
			move_on(usr)

/obj/structure/proc/move_on(var/mob/M)
	M.loc = loc
	M.pixel_z = pixelzheight
	M.onstructure = 1
	..()
	M.pixel_z = pixelzheight

/obj/structure/proc/leave(var/mob/M)
	M.onstructure = 0
	M.pixel_z = 0