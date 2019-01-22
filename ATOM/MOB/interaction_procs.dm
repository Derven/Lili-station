/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/detective_scanner))
		for(var/mob/O in viewers(src, null))
			if (O.client)
				O << "\red [src] has been scanned by [user] with the [W]"
	else
		if (!( istype(W, /obj/item/weapon/grab) ) && !(istype(W, /obj/item/weapon/plastique)) &&!(istype(W, /obj/item/weapon/cleaner)) &&!(istype(W, /obj/item/weapon/chemsprayer)) &&!(istype(W, /obj/item/weapon/pepperspray)) && !(istype(W, /obj/item/weapon/plantbgone)) )
			for(var/mob/O in viewers(src, null))
				if (O.client)
					if(O.intent == 0)
						//O << text("\red <B>[] גû בüועו [] ס ןמלמשü‏ []</B>", src, user, W)
						O <<  "\red <B>[] has been attacked by [] with the []</B>"
	return

/atom/Click()
	var/mob/M = usr
	sleep(rand(1,2))
	return M.myclick(src)

/mob
	Bump(var/atom/A)
		if(istype(src, /mob/ghost) || !client)
			return
		if(istype(A, /obj/structure))
			var/obj/structure/S = A
			if(S.anchored == 0 && S.density == 1)
				step(S, dir, 64)

		if(istype(A, /mob))
			if(A.density == 1)
				if(intent == 0)
					step(A, dir, 64)
				else
					A.density = 0
					step(src, turn(A.dir, 180), 64)
					step(A, dir, 64)
					A.density = 1

		if(istype(A, /obj/machinery/airlock))
			var/obj/machinery/airlock/A_LOCK = A
			var/turf/simulated/floor/T = A.loc
			if(A_LOCK.charge == 0)
				return
			else
				if(istype(src, /mob/simulated/living/humanoid))
					var/mob/simulated/living/humanoid/user = src
					if(user.id && A_LOCK.ID.check_id(user.id))
						if(istype(A_LOCK, /obj/machinery/airlock/brig/briglock))
							return
						if(A_LOCK.close)
							A_LOCK.open()
						else
							A_LOCK.close()
						if(istype(A.loc, /turf/simulated))
							T.update_air_properties()

/atom/proc/attack_self()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
	if(istype(src, /obj/item/projectile))
		del(src)
	return 0

/atom/movable/Bump(var/atom/A as mob|obj|turf)
	spawn( 0 )
		if ((A))
			A.Bumped(src)
		return
	..()
	return

/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return

	usr << "This is \an [name]."
	usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

atom/proc/attack_hand()

/atom/MouseEntered()
	if(istype(usr, /mob/simulated))
		if(usr.mycraft == null)
			usr.cur_object_i_see = src
			usr.select_overlay.icon = icon
			usr.select_overlay.icon_state = icon_state
			usr.select_overlay.layer = layer
			usr.select_overlay.loc = src
			usr.select_overlay.overlays.Cut()
			if(istype(src, /mob))
				usr.select_overlay.overlays += src.overlays
			if(!istype(src, /obj/hud) && !istype(src, /obj/lobby) && !istype(src, /turf/simulated/floor/roof) && !(ZLevel > usr.ZLevel))
				if(usr.usrcolor)
					usr.select_overlay.color = usr.usrcolor
				else
					usr.select_overlay.color = "#c0e0ff"
				usr << usr.select_overlay
		else
			if(get_dist(usr, src) < 2)
				usr.mycraft.loc = src
				usr.mycraft.color = "green"
				usr << usr.mycraft

/atom/MouseExited()
	usr.client.images -= usr.select_overlay
	if(usr.mycraft)
		usr.client.images -= usr.mycraft

/atom/proc/MouseDrop_T()
	return

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return