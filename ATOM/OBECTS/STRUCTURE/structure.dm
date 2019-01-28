/mob
	var/onstructure = 0


/obj/structure
	var/pixelzheight = 16
	robustness = 15

	verb/climb_up()
		set src in range(1)
		if(usr.do_after(pixelzheight))
			move_on(usr)

	CanPass(var/atom/A)
		if(istype(A, /mob))
			var/mob/M = A
			return M.onstructure
		return 0

	Uncrossed(var/mob/M)
		leave(M)

	proc/move_on(var/mob/M)
		M.loc = loc
		M.pixel_z = pixelzheight
		M.onstructure = 1

	proc/leave(var/mob/M)
		M.onstructure = 0
		M.pixel_z = 0