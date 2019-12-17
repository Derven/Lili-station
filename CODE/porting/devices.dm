/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon = 'tools.dmi'
	icon_state = "analyser"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | TABLEPASS| CONDUCT
	m_amt = 30
	g_amt = 20
	origin_tech = "magnets=1;engineering=1"
	pdaslot = 1

/obj/item/device/analyzer/attack_self()

	var/mob/simulated/living/humanoid/user = usr
	if (user.stat)
		return
	if (!(istype(usr, /mob/simulated/living/humanoid)))
		usr << "\red You don't have the dexterity to do this!"
		return

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.show_message("\blue <B>Results:</B>", 1)
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user.show_message("\blue Pressure: [round(pressure,0.1)] kPa", 1)
	else
		user.show_message("\red Pressure: [round(pressure,0.1)] kPa", 1)
	if(total_moles)
		var/o2_concentration = environment.oxygen/total_moles
		var/n2_concentration = environment.nitrogen/total_moles
		var/co2_concentration = environment.carbon_dioxide/total_moles
		var/plasma_concentration = environment.toxins/total_moles

		var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
		if(abs(n2_concentration - N2STANDARD) < 20)
			user.show_message("\blue Nitrogen: [round(n2_concentration*100)]%", 1)
		else
			user.show_message("\red Nitrogen: [round(n2_concentration*100)]%", 1)

		if(abs(o2_concentration - O2STANDARD) < 2)
			user.show_message("\blue Oxygen: [round(o2_concentration*100)]%", 1)
		else
			user.show_message("\red Oxygen: [round(o2_concentration*100)]%", 1)

		if(co2_concentration > 0.01)
			user.show_message("\red CO2: [round(co2_concentration*100)]%", 1)
		else
			user.show_message("\blue CO2: [round(co2_concentration*100)]%", 1)

		if(plasma_concentration > 0.01)
			user.show_message("\red Plasma: [round(plasma_concentration*100)]%", 1)

		if(unknown_concentration > 0.01)
			user.show_message("\red Unknown: [round(unknown_concentration*100)]%", 1)

		user.show_message("\blue Temperature: [round(environment.temperature-T0C)]&deg;C", 1)

	return

/obj/item/device/injector_control
	name = "injector control device"
	icon = 'tools.dmi'
	icon_state = "atmos_control"
	var/body

	attack_self()
		body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Injector system consol:<hr><table class=\"pure-table\"><thead><tr><th>Injector</th><th>Coordinates</th></tr></thead><tbody>"
		for(var/obj/machinery/atmospherics/unary/OI in world)
			body += "<tr><td>Device #<a href='?src=\ref[src];oid=[OI.id];'>[OI.id];[OI.name];[OI.on == 1 ? "On" : "Off"]</a></td><td>[OI.x];[OI.y]</td></tr>"
		usr << browse(body,"window=injector")

	Topic(href,href_list[])
		if(href_list["oid"])
			var/o_id = text2num(href_list["oid"])
			for(var/obj/machinery/atmospherics/unary/OI in world)
				if(OI.id == o_id)
					OI.on = !OI.on

/obj/overlay

/obj/dummy/chameleon
	name = ""
	desc = ""
	density = 0
	anchored = 1
	var/can_move = 1
	var/obj/item/device/chameleon/master = null
	attackby()
		for(var/mob/M in src)
			M << "\red Your chameleon-projector deactivates."
		master.disrupt()
	attack_hand()
		for(var/mob/M in src)
			M << "\red Your chameleon-projector deactivates."
		master.disrupt()
	ex_act()
		for(var/mob/M in src)
			M << "\red Your chameleon-projector deactivates."
		master.disrupt()
	bullet_act()
		for(var/mob/M in src)
			M << "\red Your chameleon-projector deactivates."
		master.disrupt()
	relaymove(var/mob/user, direction)
		if(can_move)
			can_move = 0
			spawn(10) can_move = 1
			step(src,direction)
		return

/obj/item/device/chameleon
	icon = 'tools.dmi'
	name = "chameleon-projector"
	icon_state = "chamel"
	flags = FPRINT | TABLEPASS| CONDUCT | USEDELAY | ONBELT
	item_state = "electronic"
	w_class = 2.0
	origin_tech = "syndicate=4;magnets=4"
	var/can_use = 1
	var/obj/dummy/chameleon/active_dummy = null
	var/saved_item = "/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice"

	dropped()
		disrupt()

	attack_self()
		toggle()

	afterattack(atom/target, mob/user , flag)
		if(istype(target,/obj/item))
			usr << "\blue Scanned [target]."
			saved_item = target.type

	proc/toggle()
		if(!can_use || !saved_item) return
		if(active_dummy)
			for(var/atom/movable/A in active_dummy)
				A.loc = get_turf(active_dummy)
				if(ismob(A))
					if(A:client)
						A:client:eye = A
			del(active_dummy)
			active_dummy = null
			usr << "\blue You deactivate the [src]."
			var/obj/overlay/T = new/obj/overlay(get_turf(src))
			T.icon = 'effects.dmi'
			flick("emppulse",T)
			spawn(8) del(T)
		else
			var/obj/O = new saved_item (src)
			if(!O) return
			var/obj/dummy/chameleon/C = new/obj/dummy/chameleon(get_turf(src))
			C.name = O.name
			C.desc = O.desc
			C.icon = O.icon
			C.icon_state = O.icon_state
			C.dir = O.dir
			usr.loc = C
			C.master = src
			src.active_dummy = C
			del(O)
			usr << "\blue You activate the [src]."
			var/obj/overlay/T = new/obj/overlay(get_turf(src))
			T.icon = 'effects.dmi'
			flick("emppulse",T)
			spawn(8) del(T)

	proc/disrupt()
		if(active_dummy)
			for(var/atom/movable/A in active_dummy)
				A.loc = get_turf(active_dummy)
				if(ismob(A))
					if(A:client)
						A:client:eye = A
			del(active_dummy)
			active_dummy = null
			can_use = 0
			spawn(100) can_use = 1

/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'tools.dmi'
	icon_state = "flashlight"
	inhandstate = "flashlight"
	var/on = 0
	lumpower = 5

	attack_hand()
		..()
		update_brightness(usr)

/obj/item/device/flashlight/initialize()
	..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
		SetLuminosity(0)

/obj/item/device/flashlight/proc/update_brightness(var/mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(loc == usr)
			usr.SetLuminosity(lumpower)
			usr.lumpower = lumpower
		else if(isturf(loc))
			SetLuminosity(lumpower)
	else
		icon_state = initial(icon_state)
		if(loc == user)
			usr.SetLuminosity(0)
			usr.lumpower = lumpower
		else if(isturf(loc))
			SetLuminosity(0)


/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(usr.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	update_brightness(usr)
	return 1

/obj/screen

/obj/item/weapon/radar
	name = "mind radar"
	icon = 'tools.dmi'
	icon_state = "analyser"
	var/mob/seeker
	pdaslot = 0
	var/on = 0

	New()
		..()
		processing_objects.Add(src)

/obj/item/weapon/radar/process()
	if(!on)
		return
	if(!seeker)
		on = !on
		icon_state = "analyser"
		return
	ping()

/obj/item/weapon/radar/attack_self()
	if(!on)
		seeker = usr
		turn_on()
	else
		turn_off()
		seeker = null

/obj/item/weapon/radar/proc/ping()
	clear_screen()	//Here's no time for optimization!

	var/turf/T = get_turf(src)
	for(var/mob/simulated/living/L in range(T, 16))
		var/xdiff = (L.x - T.x) * 2 - 1
		var/ydiff = (L.y - T.y) * 2 - 1
		var/obj/screen/S = new
		S.name = "ping"
		S.icon = 'radar.dmi'
		S.icon_state = "civblip"
		S.screen_loc = "NORTH - 1 : [ydiff], EAST - 1 : [xdiff]"
		S.layer = 22
		seeker.client.screen += S

/obj/item/weapon/radar/proc/turn_on()
	if(!seeker)
		return
	if(!seeker.client)
		return
	if(on)
		return
	on = 1
	icon_state = "analyser" //CAUSE HARDCODE WORK BETTER @:

	var/obj/screen/S = new
	S.name = "radar"
	S.icon = 'radar.dmi'
	S.icon_state = "radarSW"
	S.screen_loc = "NORTH - 2, EAST - 2"
	S.alpha = 128
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'radar.dmi'
	S.icon_state = "radarSE"
	S.screen_loc = "NORTH - 2, EAST - 1"
	S.alpha = 128
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'radar.dmi'
	S.icon_state = "radarNW"
	S.screen_loc = "NORTH - 1, EAST - 2"
	S.alpha = 128
	S.layer = 20
	seeker.client.screen += S

	S = new
	S.name = "radar"
	S.icon = 'radar.dmi'
	S.icon_state = "radarNE"
	S.screen_loc = "NORTH - 1, EAST - 1"
	S.alpha = 128
	S.layer = 20
	seeker.client.screen += S

/obj/item/weapon/radar/proc/turn_off()
	if(!seeker)
		return
	if(!seeker.client)
		return
	on = 0
	icon_state = "analyser"

	clear_screen()
	for(var/obj/screen/S in seeker.client.screen)
		if(S.name == "radar")
			seeker.client.screen -= S

/obj/item/weapon/radar/proc/clear_screen()
	if(!seeker || !seeker.client)
		return
	for(var/obj/screen/S in seeker.client.screen)
		if(S.name == "ping")
			seeker.client.screen -= S

/obj/item/weapon/radar/dropped(var/mob/M)
	turn_off()
	seeker = null

