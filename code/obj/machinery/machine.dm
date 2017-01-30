/obj/machinery
	name = "machinery"
	icon = 'stationobjs.dmi'
	var
		switcher = 0
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


/obj/machinery/motor
	idle_power_usage = 0
	use_power = 1
	icon_state = "motor_off"
	icon = 'motor.dmi'

	proc/on()
		idle_power_usage = 5000
		icon_state = "motor_on"

	proc/off()
		idle_power_usage = 0
		icon_state = "motor_off"

/obj/machinery/lamp
	power_channel = LIGHT
	idle_power_usage = 100
	switcher = 1
	use_power = 1
	anchored = 1

/obj/machinery/lamp/process()
	if(!powered())
		luminosity = 0
		return
	else
		luminosity = 6

/obj/machinery/New()
	..()
	machines.Add(src)

/obj/machinery/power_eat
	use_power = 1
	idle_power_usage = 1200

/obj/machinery/Del()
	machines.Remove(src)
	..()

/obj/machinery/process()//If you dont use process or power why are you here
//	machines.Remove(src)Not going to do this till I test it a bit more
	return

/obj/machinery/proc/auto_use_power()
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

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++
