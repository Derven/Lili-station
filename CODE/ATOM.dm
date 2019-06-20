//atom vars
//---------------------
/atom/layer = 2
/atom/var/ZLevel = 1
/atom/var/Climbing
/atom/var/level = 2
/atom/var/last_bumped = 0
/atom/var/pass_flags = 0
//---------------------

//atom procs
//---------------------
/atom/Click(location,control,params)
	var/mob/M = usr
	sleep(rand(1,2))
	usr.ClickOn(src, params)
	return M.myclick(src)

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
				if(!istype(usr.mycraft.loc, /obj/hud))
					usr.mycraft.color = "green"
					usr << usr.mycraft

/atom/MouseExited()
	usr.client.images -= usr.select_overlay
	if(usr.mycraft)
		usr.client.images -= usr.mycraft

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/proc/show_message(var/msg)
	src << msg

/atom/proc/ShiftClickOn()
	if(usr.client && usr.client.eye == usr)
		examine_me(usr)
	return

/atom/proc/MouseDrop_T()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	del(giver)
	return 0

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/atom/proc/attack_self()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/proc/bullet_act(var/obj/item/projectile/Proj)
	if(istype(src, /obj/item/projectile))
		del(src)
	return 0

/atom/proc/examine_me(var/mob/M)
	if (!( M ))
		return

	M << "This is \an [name]."
	M << desc

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

/atom/proc/relaymove()
	return

/atom/proc/attack_hand()

/atom/proc/ex_act()
	for(var/mob/M in range(2, src))
		M.playsoundforme('Explosion2.ogg')
		if(rand(1, 100) < 100 - robustness)
			if(!istype(src, /mob))
				del(src)
			else
				if(istype(src, /mob/simulated))
					var/mob/simulated/S = src
					S.death()
					del(src)

/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/O in viewers(src, null))
		if (O.client)
			if(O.intent == 0)
				//O << text("\red <B>[] גû בüועו [] ס ןמלמשü‏ []</B>", src, user, W)
				O <<  "\red <B>[src] has been attacked by [usr] with the [W]</B>"
	return