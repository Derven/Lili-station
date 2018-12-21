/obj/machinery
	name = "machinery"
	icon = 'stationobjs.dmi'
	robustness = 25
	var
		charge = 0
		load = 0
		switcher = 1
		stat = 0
		emagged = 0
		use_power = 0
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
		idle_power_usage = 0
		active_power_usage = 0
		power_channel = LIGHT
		//EQUIP,ENVIRON or LIGHT
		list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
		uid
		manual = 0
		global
			gl_uid = 1

	ex_act()
		for(var/mob/M in range(2, src))
			M.playsoundforme('Explosion2.ogg')
			if(rand(1, 100) < 100 - robustness)
				del(src)

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return
	return 0

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/New()
	..()
	machines.Add(src)

/obj/machinery/Del()
	machines.Remove(src)
	..()

/obj/machinery/process()//If you dont use process or power why are you here
//	machines.Remove(src)Not going to do this till I test it a bit more
	return

/obj/machinery/proc/auto_use_power()
	if(charge > 0)
		return 1
	else
		return 0
/*
	if(switcher)
		if(!powered(power_channel))
			return 0
		if(src.use_power == 1)
			use_power(idle_power_usage,power_channel)
		else if(src.use_power >= 2)
			use_power(active_power_usage,power_channel)
		return 1
	else
		return 0
*/

/obj/machinery/power
	name = null
	icon = 'power.dmi'
	anchored = 1.0
	var/datum/powernet/powernet = null
	var/netnum = 0
	var/directwired = 1		// by default, power machines are connected by a cable in a neighbouring turf
							// if set to 0, requires a 0-X cable on this turf
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0