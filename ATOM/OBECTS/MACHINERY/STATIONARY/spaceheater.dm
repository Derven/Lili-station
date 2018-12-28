/obj/machinery/space_heater
	anchored = 1
	density = 1
	icon = 'stationobjs.dmi'
	icon_state = "sheater"
	name = "space heater"
	var/on = 1
	var/open = 0
	var/set_temperature = 70		// in celcius, add T0C for kelvin
	var/heating_power = 90000

	flags = FPRINT


	New()
		..()
		update_icon()
		return


	examine()
		set src in oview(12)
		if (!( usr ))
			return
		usr << "This is \icon[src] \an [src.name]."
		return



	process()
		if(on)
			var/turf/simulated/L = loc
			if(istype(L))
				var/datum/gas_mixture/env = L.return_air()
				if(env.temperature < (set_temperature+T0C))

					var/transfer_moles = 0.25 * env.total_moles

					var/datum/gas_mixture/removed = env.remove(transfer_moles)

						//world << "got [transfer_moles] moles at [removed.temperature]"

					if(removed)

						var/heat_capacity = removed.heat_capacity()
							//world << "heating ([heat_capacity])"
						if(heat_capacity == 0 || heat_capacity == null) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
							heat_capacity = 1
						removed.temperature = (removed.temperature*heat_capacity + heating_power)/1 // Added min() check to try and avoid wacky superheating issues in low gas scenarios -- TLE

						//world << "now at [removed.temperature]"

					env.merge(removed)
					//world << "turf now at [env.temperature]"


			else
				on = 0
				update_icon()


		return

	space_cooler
		set_temperature = -15
		name = "space cooler"


		process()

			if(on)
				var/turf/simulated/L = loc
				if(istype(L))
					var/datum/gas_mixture/env = L.return_air()
					if(env.temperature > (set_temperature+T0C))

						var/transfer_moles = 0.25 * env.total_moles

						var/datum/gas_mixture/removed = env.remove(transfer_moles)

							//world << "got [transfer_moles] moles at [removed.temperature]"

						if(removed)

							var/heat_capacity = removed.heat_capacity()
								//world << "heating ([heat_capacity])"
							if(heat_capacity == 0 || heat_capacity == null) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
								heat_capacity = 1
							removed.temperature = removed.temperature-10 // Added min() check to try and avoid wacky superheating issues in low gas scenarios -- TLE

						env.merge(removed)


				else
					on = 0
					update_icon()


			return