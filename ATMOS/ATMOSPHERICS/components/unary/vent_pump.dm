/obj/machinery/atmospherics/unary/vent_pump
	icon = 'vent_pump.dmi'
	icon_state = "off"

	name = "Air Vent"
	desc = "Has a valve and pump attached to it"

	level = 1
	var/area_uid
	var/id_tag
	power_channel = ENVIRON

	on = 0
	var/pump_direction = 1 //0 = siphoning, 1 = releasing
	var/pump_speed = 1 //Used to adjust speed for siphons

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/pressure_checks = 1
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	var/welded = 0 // Added for aliens -- TLE

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/radio_filter_out
	var/radio_filter_in

	high_volume
		name = "Large Air Vent"
		power_channel = EQUIP

		New()
			..()
			air_contents.volume = 1000

	attack_hand()
		if(!on || on == 0)
			on = 1
			usr << "You turn on the vent"
		else
			on = 0
			usr << "You turn off the vent"


	update_icon()
		if(welded)
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
			return
		if(on && !(stat & (NOPOWER|BROKEN)))
			if(pump_direction)
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
			else
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"

		return

	process()
		..()
//		broadcast_status()
		update_icon()
		if (!node)
			on = 0

		if(!on)
			return 0

		if(welded)
			return 0

		var/datum/gas_mixture/environment = loc.return_air()
		var/environment_pressure = environment.return_pressure()

		if(pump_direction) //internal -> external
			var/pressure_delta = 10000

			if(pressure_checks&1)
				pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
			if(pressure_checks&2)
				pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))

			if(pressure_delta > 0)
				if(air_contents.temperature > 0)
					var/transfer_moles = pressure_delta*environment.volume*environment.group_multiplier*pump_speed/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

					loc.assume_air(removed)

					if(network)
						network.update = 1

		else //external -> internal
			var/pressure_delta = 10000
			if(pressure_checks&1)
				pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
			if(pressure_checks&2)
				pressure_delta = min(pressure_delta, (internal_pressure_bound - air_contents.return_pressure()))

			if(pressure_delta > 0)
				if(environment.temperature > 0)
					var/transfer_moles = pressure_delta*air_contents.volume*air_contents.group_multiplier*pump_speed/(environment.temperature * R_IDEAL_GAS_EQUATION)

					var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
					if (isnull(removed)) //in space
						return

					air_contents.merge(removed)

					if(network)
						network.update = 1

		return 1




	//Radio remote control


	initialize()
		if(node) return

		var/node_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
			if(target.initialize_directions & get_dir(target,src))
				node = target
				break

		update_icon()
		..()

		//some vents work his own spesial way


	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(welded)
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
			return
		if(on&&node)
			if(pump_direction)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
			else
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
			on = 0
		return
/*
	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if (WT.remove_fuel(0,user))
				user << "\blue Now welding the vent."
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					if(!welded)
						user.visible_message("[user] welds the vent shut.", "You weld the vent shut.", "You hear welding.")
						welded = 1
						update_icon()
					else
						user.visible_message("[user] unwelds the vent.", "You unweld the vent.", "You hear welding.")
						welded = 0
						update_icon()
				else
					user << "\blue The welding tool needs to be on to start this task."
			else
				user << "\blue You need more welding fuel to complete this task."
				return 1
*/

	examine()
		set src in oview(1)
		..()
		if(welded)
			usr << "It seems welded shut."

	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
		if (!(stat & NOPOWER) && on)
			user << "\red You cannot unwrench this [src], turn it off first."
			return 1
		var/turf/T = src.loc
		if (level==1 && isturf(T) && T.intact)
			user << "\red You must remove the plating first."
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
			return 1
		user << "\blue You begin to unfasten \the [src]..."
		new /obj/item/pipe(loc, make_from=src)
		del(src)
