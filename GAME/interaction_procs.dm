/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/detective_scanner))
		for(var/mob/O in viewers(src, null))
			if (O.client)
				O << usr.select_lang(text("\red [src] отсканировано [user] с помощью [W]"), text("\red [src] has been scanned by [user] with the [W]"))
	else
		if (!( istype(W, /obj/item/weapon/grab) ) && !(istype(W, /obj/item/weapon/plastique)) &&!(istype(W, /obj/item/weapon/cleaner)) &&!(istype(W, /obj/item/weapon/chemsprayer)) &&!(istype(W, /obj/item/weapon/pepperspray)) && !(istype(W, /obj/item/weapon/plantbgone)) )
			for(var/mob/O in viewers(src, null))
				if (O.client)
					if(O.intent == 0)
						//O << text("\red <B>[] вы бьете [] с помощью []</B>", src, user, W)
						O << usr.select_lang(text("\red <B>[] вы бьете [] с помощью []</B>", src, user, W), text("\red <B>[] has been attacked by [] with the []</B>", src, user, W))
	return

/atom/Click()
	if(!istype(usr, /mob/ghost))
		var/obj/item/I = usr.get_active_hand()

		if(usr.throwing_mode == 1)
			if(usr.hand && usr.l_hand)
				var/obj/item/I2 = usr.l_hand
				usr.drop_item()
				I2.throw_hyuow_at(src, rand(4,9), 1)
				usr.TH.icon_state = "throw1"
			if(!usr.hand && usr.r_hand)
				var/obj/item/I2 = usr.r_hand
				usr.drop_item()
				I2.throw_hyuow_at(src, rand(4,9), 1)
				usr.TH.icon_state = "throw1"

		if(istype(I, /obj/item/weapon/gun))
			I.afterattack(src)
		if(src in range(1, usr))
			if(!usr.get_active_hand())
				attack_hand(usr)
			else
				if(src == usr.get_active_hand())
					attack_self()
				else
					attackby(usr.get_active_hand())
					if(I)
						I.afterattack(src, usr)
		else if(src.loc in range(1, usr))
			attack_hand(usr)
			for(var/obj/structure/closet/closet_3/CL in range(1, usr))
				CL.upd_closet()

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
			var/turf/simulated/floor/T = src.loc
			if(A_LOCK.charge == 0)
				return
			else
				if(istype(A_LOCK, /obj/machinery/airlock/brig/briglock)) return
				for(var/mob/M in range(5, src))
					M.playsoundforme('airlock.ogg')
				if(A_LOCK.close == 1)
					flick("open_state",A_LOCK)
					A_LOCK.icon_state = "open"
					A_LOCK.close = 0
					A_LOCK.density = 0
					A_LOCK.opacity = 0
					T.blocks_air = 0
				else
					A_LOCK.close = 1
					T.blocks_air = 1
					A_LOCK.density = 1
					A_LOCK.opacity = 1
					flick("close_state",A_LOCK)
					A_LOCK.icon_state = "close"
				T.update_air_properties()

	attack_hand()
		if(death == 0 && !istype(src, /mob/ghost))
			if(usr.intent == 0) //harm

				var/datum/organ/external/defen_zone
				if(client)
					defen_zone = get_organ(ran_zone(src.DF_ZONE.selecting))

				var/datum/organ/external/affecting = get_organ(ran_zone(usr.ZN_SEL.selecting))
				if(defen_zone)
					if(defen_zone == affecting )
						src << select_lang("\red Вы блокируете часть урона", "\red You block damage partially")
						usr << usr.select_lang("\red [src] блокирует часть урона!", "\red [src] block damage partially")
						apply_damage(rand(6, 12) - defense, "brute" , affecting, 0)
				else
					apply_damage(rand(6, 12), "brute" , affecting, 0)
				for(var/mob/M in range(5, src))
					//M << "\red [usr] бьет [src] в область [affecting]"
					M << M.select_lang("\red [usr] бьет [src] в область [affecting]", "\red [usr] punch [src] to [affecting]")
			else
				if(src.ZLevel < usr.ZLevel)
					for(var/mob/M in range(5, src))
						M << M.select_lang("\red [usr] прот&#255;гивает руку [src] и поднимает на второй этаж", "\red [usr] lift [src] to [usr.ZLevel] level")
					src.Move(usr.loc)
					src.ZLevel = usr.ZLevel
					layer = 17
					pixel_z = 32 * (ZLevel - 1)
				return


/atom/proc/attack_self()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
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

	usr << usr.select_lang("Это [name].", "This is \an [name].") //here
	usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

atom/proc/attack_hand()

/atom/MouseEntered()
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