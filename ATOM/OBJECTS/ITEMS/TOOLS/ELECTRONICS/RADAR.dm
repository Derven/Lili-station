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

