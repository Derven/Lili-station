
/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'outlet_injector.dmi'
	icon_state = "off"

	name = "Air Injector"
	desc = "Has a valve and pump attached to it"

	on = 0
	var/injecting = 0

	var/volume_rate = 50
	id = null

	level = 1

	New()
		injectors += 1
		id = injectors
		..()

	update_icon()
		if(node)
			if(on)
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]on"
			else
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
		else
			icon_state = "exposed"
			on = 0

		return

	process()
		..()
		injecting = 0

		if(!on)
			return 0

		if(air_contents.temperature > 0)
			var/transfer_moles = (air_contents.return_pressure())*volume_rate/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

			loc.assume_air(removed)

			if(network)
				network.update = 1

		return 1

	proc/inject()
		if(on || injecting)
			return 0

		injecting = 1

		if(air_contents.temperature > 0)
			var/transfer_moles = (air_contents.return_pressure())*volume_rate/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

			loc.assume_air(removed)

			if(network)
				network.update = 1

		flick("inject", src)