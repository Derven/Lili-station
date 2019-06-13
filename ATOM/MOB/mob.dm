var/list/restartY = list()
var/list/restartN = list()
var/restarted = 0

/mob/var/usrcolor
/datum/restarter
	Topic(href,href_list[])
		if(href_list["yesorno"] == "y")
			restartN.Remove(usr.key)
			restartY.Add(usr.key)
		if(href_list["yesorno"] == "n")
			restartY.Remove(usr.key)
			restartN.Add(usr.key)

var/datum/restarter/reSTARter = new /datum/restarter()

/mob
	verb/vote_restart()
		set category = "OOC"
		if(restarted == 0)
			restarted = 1
			restartY.Cut()
			restartN.Cut()
			for(var/mob/M in world)
				if(M.client)
					M << "\red <h3>Vote for restart</h3>"
					M << "<a href='?src=\ref[reSTARter];yesorno=y'>Y</a>;<a href='?src=\ref[reSTARter];yesorno=n'>N</a>"
			spawn(500)
				if(length(restartY) > length(restartN))
					world << "\blue <h1>THE WORLD reSTARded***</h1>"
					world.Reboot(1)
					restarted = 0
				else
					world << "No restart"
					restarted = 0

	proc/myclick(var/atom/A)
		var/mob/simulated/living/humanoid/H = usr
		if(istype(H, /mob/simulated/living/humanoid))
			if(H.handcuffed == 0)
				var/obj/item/I = H.get_active_hand()

				if(H.throwing_mode == 1)
					if(H.hand && H.l_hand)
						var/obj/item/I2 = H.l_hand
						H.drop_item()
						I2.throw_hyuow_at(src, A, rand(4,9), 1)
						H.throwing_mode = 0
						H.TH.icon_state = "throw1"
					if(!H.hand && H.r_hand)
						var/obj/item/I2 = H.r_hand
						H.drop_item()
						I2.throw_hyuow_at(src, A, rand(4,9), 1)
						H.throwing_mode = 0
						H.TH.icon_state = "throw1"

				if(get_dist(src, A) < 2)
					if(istype(I, /obj/item/weapon/gun))
						I.afterattack(A)
					if(src in range(1, usr))
						if(!H.get_active_hand())
							A.attack_hand(usr)
						else
							if(A == H.get_active_hand())
								A.attack_self()
							else
								A.attackby(H.get_active_hand())
								if(I)
									I.afterattack(A, usr)
					else if(A.loc in range(1, usr))
						A.attack_hand(usr)
/mob/var/next_click= 0
/mob/proc/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		A.ShiftClickOn()
		return

/atom/proc/ShiftClickOn()
	if(usr.client && usr.client.eye == usr)
		examine_me(usr)
	return

mob
	var/job = "assistant"
	step_size = 64
	layer = 18
	density = 1
	layer = 18.0
	animate_movement = 2
	flags = NOREACT
	var/turf/SLOC = null
	//var/list/obj/last_contents = list()
	//MOB overhaul
	//Not in use yet
	//var/obj/organstructure/organStructure = null

	//Vars that have been relocated to organStructure
	//Vars that have been relocated to organStructure ++END
	var/obj/machinery/machine = null
	var/next_move = null
	var/image/select_overlay
	//Vars that should only be accessed via procs
	var/stat = 0

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	verb/moveplus45degree()
		if(client)
			client.north = 0
			client.west = 0
			client.east = 0
			client.south = 0
			client.southwest = 0
			client.northwest = 0
			client.northeast = 0
			client.southeast = 0
			if(client.moving45 == 0)
				client.moving45 = 1
				return
			else
				client.moving45 = 0
				return
	New()
		..()
		select_overlay = image(usr)
		usr.select_overlay.override = 1

/client/verb/windowclose(var/atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

	//world << "windowclose: [atomref]"
	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		var/href = "close=1"
		if(hsrc)
			//world << "[src] Topic [href] [hsrc]"
			usr = src.mob
			src.Topic(href, params2list(href), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
		//world << "[src] was [src.mob.machine], setting to null"
		src.mob.machine = null
	return

/mob

/mob
	icon = 'mob.dmi'
	icon_state = "mob"
	layer = 15
	var/inertia_dir = 0
	var/death = 0
	var/intent = 1 //1 - help, 0 - harm
	//pain

	proc/check_topic(var/atom/ATOM)
		if(get_dist(src,ATOM) > 1)
			return 0
		else
			return 1

/atom/proc/relaymove()
	return

/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

/mob/New()
	..()
	if(length(landmarks) > 0)
		Move(pick(landmarks))
/*
/mob/proc/show_lobby()
	lobby_text = " \
	<html> \
		<head> \
			<title> lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #1CBED5; width: 100%; border: 4px double #CE24CB;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=observe'>OBSERVE</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>Lili station</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> <a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> <a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> <a href='?src=\ref[src];doc=0'>select</a><br> \
				<span class='cap' style=\"{color: blue};\">Captain</span> <a href='?src=\ref[src];cap=0'>select</a><br> \
			</div> \
		</body> \
	</html>"
	usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")

/mob/proc/lobby_refresh()
	lobby_text = " \
	<html> \
		<head> \
			<title> lobby </title> \
		</head> \
		<body> \
			<div class=lobby> \
				<span class=miniheader style=\"{color: #FFDE40; background-color: #1CBED5; width: 100%; border: 4px double #CE24CB;}\">\
				<a href='?src=\ref[src];enter=yes'>JOIN</a> / <a href='?src=\ref[src];enter=observe'>OBSERVE</a> / <a href='?src=\ref[src];enter=nahoy'> EXIT </span></a> \
				<br> \
				<center><h1>Lili station</h1></center> \
				<h3><a href='?src=\ref[src];name=newname'>NAME</a><br> \
				SELECTING <a href='?src=\ref[src];color=select'>COLOR</a><br> \
				GENDER <a href='?src=\ref[src];gender=male'> MALE </a> / <a href='?src=\ref[src];gender=female'> FEMALE </a><br> \
				<a href='?src=\ref[src];hair=new'> HAIR </a><br> \
				<a href='?src=\ref[src];display=show'>SCREEN RESOLUTION</a></h3></div> \
				<h3>JOBS:</h3><hr> \
				<span class='gray' style=\"{color: darkgray};\">Assistant</span> <a href='?src=\ref[src];assist=1'>select</a> <br> \
				<span class='green' style=\"{color: darkgreen};\">Botanist</span> <a href='?src=\ref[src];botanist=0'>select</a><br> \
				Bartender <a href='?src=\ref[src];bart=0'>select</a><br>  \
				<span class='sec' style=\"{color: darkred};\">Security</span> <a href='?src=\ref[src];sec=0'>select</a><br>\
				<span class='eng' style=\"{color: orange};\">Engineer</span> <a href='?src=\ref[src];eng=0'>select</a><br> \
				<span class='doc' style=\"{color: darkblue};\">Doctor</span> <a href='?src=\ref[src];doc=0'>select</a><br> \
				<span class='cap' style=\"{color: blue};\">Captain</span> <a href='?src=\ref[src];cap=0'>select</a><br> \
			</div> \
		</body> \
	</html>"
	usr << browse(lobby_text,"window=setup;size=350x500;can_resize=0;can_close=0")
*/
client
	var/played = 0

//mob/var/atom/cur_object_i_give
mob/var/atom/cur_object_i_see
mob/var/inlobby = 1
	//if(!istype(cur_object_i_give, /mob) && cur_object_i_give && cur_object_i_give.contents.len > 0) statpanel("container", cur_object_i_give.contents)

/mob/verb/Change_Volume(newv as num)
	set name = "Change Volume(0-75)"
	set category = "OOC"
	if(newv > 75  || newv < 0) src << "\red Your number is out of 0-75 range."
	client.sound_volume = newv

/client
	var/sound_volume = 45 //From 0 to 30

/mob/proc/playsoundforme(sound/S as sound)
	if(client)
		usr << sound(S,0,0,0,client.sound_volume)