/obj/machinery/airlock
	icon = 'airlock.dmi'
	icon_state = "close"
	power_channel = ENVIRON
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 1
	anchored = 1

	var
		close = 1

	New()
		..()
		var/turf/simulated/floor/T = src.loc
		T.blocks_air = 1
		T.update_air_properties()

	attack_hand(mob/user)
		power_change()
		var/turf/simulated/floor/T = src.loc
		if(!powered())
			return
		else
			if(close == 1)
				icon_state = "open"
				close = 0
				density = 0
				T.blocks_air = 0
			else
				close = 1
				T.blocks_air = 1
				density = 1
				icon_state = "close"
			T.update_air_properties()