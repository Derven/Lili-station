/mob/var/usrcolor

client
	var/STFU_ghosts		//80+ people rounds are fun to admin when text flies faster than airport security
	var/STFU_radio		//80+ people rounds are fun to admin when text flies faster than airport security

/mob
	proc/myclick(var/atom/A)
		var/mob/simulated/living/humanoid/H = usr
		if(istype(H, /mob/simulated/living/humanoid))
			if(H.handcuffed == 0)
				var/obj/item/I = H.get_active_hand()

				if(H.throwing_mode == 1)
					if(H.hand && H.l_hand)
						var/obj/item/I2 = H.l_hand
						H.drop_item()
						I2.throw_hyuow_at(A, rand(4,9), 1)
						H.throwing_mode = 0
						H.TH.icon_state = "throw1"
					if(!H.hand && H.r_hand)
						var/obj/item/I2 = H.r_hand
						H.drop_item()
						I2.throw_hyuow_at(A, rand(4,9), 1)
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
	var/death = 0
	var/intent = 1 //1 - help, 0 - harm
	//pain

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