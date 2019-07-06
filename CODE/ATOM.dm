//atom vars
//---------------------
/atom/layer = 2
/atom/var/ZLevel = 1
/atom/var/Climbing
/atom/var/level = 2
/atom/var/last_bumped = 0
/atom/var/pass_flags = 0
/atom/var/middle_move_right_objects = 0
//---------------------

//atom procs
//---------------------

/atom/MouseMove(location,control,params)
	if(get_dist(usr, src) <= 2)
		sleep(1)
		usr.dir = turn(get_dir(src, usr), 180)

/atom/Click(location,control,params)
	var/mob/M = usr
	sleep(rand(1,2))
	var/list/myparapams = params2list(params)
	for(var/param in myparapams)
		if(param == "right")
			var/popup_text
			if(usr.middle_move_right_objects == 0)
				popup_text = {"
				<html>
				<head><title> Popup menu </title>
				<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/pure-min.css" integrity="sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w" crossorigin="anonymous">
				</head><body>
				<table class="pure-table">
				<thead>
				<tr>
					<th>Names</th>
					<th>Actions</th>
				</tr>
				</thead>
				<tbody><td>
				"}
				if(istype(src, /mob))
					return
				if(istype(src, /turf))
					for(var/atom/A in src)
						if(!istype(A, /mob))
							popup_text += {"<tr><td>[A]</td><td>"}
							for(var/iverb in A.verbs)
								var/myverb = findtext("[iverb]","/verb/", 1, -1)
								var/iamverb = copytext("[iverb]",myverb + 6,0)
								popup_text += "<a href='?src=\ref[TC];action=[iamverb];target=\ref[A]'>[iamverb]</a><br>"
							popup_text += "</td></tr>"
				popup_text += {"<tr><td>[src]</td><td>"}
				for(var/iverb in src.verbs)
					var/myverb = findtext("[iverb]","/verb/", 1, -1)
					var/iamverb = copytext("[iverb]",myverb + 6,0)
					popup_text += "<a href='?src=\ref[TC];action=[iamverb];target=\ref[src]'>[iamverb]</a><br>"
				popup_text += "</td></tr>"
				popup_text += "</tbody></html>"
				usr << browse(popup_text,"window=popup")
				return
			else
				var/image/movingimage = image('floors.dmi',src,"movement_overlay",15)
				var/movelag = 0
				if(istype(usr, /mob/simulated/living/humanoid))
					var/hungryeffect = 0
					if(usr && usr:nutrition < 150)
						hungryeffect = 1
					var/area/A = usr.loc.loc
					var/gravity = A.gravitypower
					var/sleepy = usr.client:run_intent - round(usr:heart.pumppower/100) + hungryeffect + gravity
					movelag += sleepy
				usr << movingimage
				spawn(3)
					del(movingimage)
				walk_to(usr,src,0,movelag,64)

		if(param == "middle")
			var/popup_text
			if(usr.middle_move_right_objects == 0)
				var/image/movingimage = image('floors.dmi',src,"movement_overlay",15)
				var/movelag = 0
				if(istype(usr, /mob/simulated/living/humanoid))
					var/hungryeffect = 0
					if(usr && usr:nutrition < 150)
						hungryeffect = 1
					var/area/A = usr.loc.loc
					var/gravity = A.gravitypower
					var/sleepy = usr.client:run_intent - round(usr:heart.pumppower/100) + hungryeffect + gravity
					movelag += sleepy
				usr << movingimage
				spawn(3)
					del(movingimage)
				walk_to(usr,src,0,movelag,64)
			else
				popup_text = {"
				<html>
				<head><title> Popup menu </title>
				<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/pure-min.css" integrity="sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w" crossorigin="anonymous">
				</head><body>
				<table class="pure-table">
				<thead>
				<tr>
					<th>Names</th>
					<th>Actions</th>
				</tr>
				</thead>
				<tbody><td>
				"}
				if(istype(src, /mob))
					return
				if(istype(src, /turf))
					for(var/atom/A in src)
						if(!istype(A, /mob))
							popup_text += {"<tr><td>[A]</td><td>"}
							for(var/iverb in A.verbs)
								var/myverb = findtext("[iverb]","/verb/", 1, -1)
								var/iamverb = copytext("[iverb]",myverb + 6,0)
								popup_text += "<a href='?src=\ref[TC];action=[iamverb];target=\ref[A]'>[iamverb]</a><br>"
							popup_text += "</td></tr>"
				popup_text += {"<tr><td>[src]</td><td>"}
				for(var/iverb in src.verbs)
					var/myverb = findtext("[iverb]","/verb/", 1, -1)
					var/iamverb = copytext("[iverb]",myverb + 6,0)
					popup_text += "<a href='?src=\ref[TC];action=[iamverb];target=\ref[src]'>[iamverb]</a><br>"
				popup_text += "</td></tr>"
				popup_text += "</tbody></html>"
				usr << browse(popup_text,"window=popup")
				return
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