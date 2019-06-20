//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:05
#define STATE_DEFAULT 1
#define STATE_INJECTOR  2
#define STATE_ENGINE 3


/obj/machinery/consol/am_engine
	name = "Antimatter Engine Console"
	icon = 'stationobjs.dmi'
	icon_state = "consol"
	var/engine_id = 0
	var/authenticated = 0
	var/obj/machinery/power/am_engine/engine/connected_E = null
	var/obj/machinery/power/am_engine/injector/connected_I = null
	var/state = STATE_DEFAULT

/obj/machinery/consol/am_engine/New()
	..()
	spawn( 24 )
		for(var/obj/machinery/power/am_engine/engine/E in world)
			if(E.engine_id == src.engine_id)
				src.connected_E = E
		for(var/obj/machinery/power/am_engine/injector/I in world)
			if(I.engine_id == src.engine_id)
				src.connected_I = I
	return

/obj/machinery/consol/am_engine/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("activate")
			src.connected_E.engine_process()
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("engine")
			src.state = STATE_ENGINE
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("injector")
			src.state = STATE_INJECTOR
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("main")
			src.state = STATE_DEFAULT
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("login")
			authenticated = 1
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("deactivate")
			src.connected_E.stopping = 1
			usr << browse(null, "window=communications")
			attack_hand(usr)
		if("logout")
			authenticated = 0
			usr << browse(null, "window=communications")
			attack_hand(usr)

/obj/machinery/consol/am_engine/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "<head><title>Engine Computer</title></head><body>"
	switch(src.state)
		if(STATE_DEFAULT)
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=engine'>Engine Menu</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=injector'>Injector Menu</A> \]"
		if(STATE_INJECTOR)
			if(src.connected_I.injecting)
				dat += "<BR>\[ Injecting \]<br>"
			else
				dat += "<BR>\[ Injecting not in progress \]<br>"
		if(STATE_ENGINE)
			if(src.connected_E.stopping)
				dat += "<BR>\[ STOPPING \]"
			else if(src.connected_E.operating && !src.connected_E.stopping)
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=deactivate'>Emergency Stop</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=activate'>Activate Engine</A> \]"
			dat += "<BR>Contents:<br>[src.connected_E.H_fuel]kg of Hydrogen<br>[src.connected_E.antiH_fuel]kg of Anti-Hydrogen<br>"

	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")
