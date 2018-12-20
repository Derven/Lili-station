/obj/machinery/airlock
	name = "airlock"
	icon = 'airlock.dmi'
	icon_state = "close"
	power_channel = ENVIRON
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 1
	opacity = 1
	anchored = 1
	switcher = 1

	load = 25
	var
		close = 1

	New()
		..()
		var/turf/simulated/floor/T = src.loc
		T.blocks_air = 1

	attack_hand(mob/user)
		var/turf/simulated/floor/T = src.loc
		if(charge == 0)
			return
		else
			for(var/mob/M in range(5, src))
				M << 'airlock.ogg'
			if(close == 1)
				flick("open_state",src)
				icon_state = "open"
				close = 0
				density = 0
				opacity = 0
				sd_SetOpacity(0)
				T.blocks_air = 0

			else
				sd_SetOpacity(1)
				close = 1
				T.blocks_air = 1
				density = 1
				opacity = 1
				flick("close_state",src)
				icon_state = "close"
			..()

	green
		icon = 'airlock_green.dmi'

/obj/machinery/airlock/firedor
	name = "firedoor"
	icon = 'firedoor.dmi'
	icon_state = "open"
	power_channel = ENVIRON
	use_power = 1
	idle_power_usage = 1200
	active_power_usage = 1000
	density = 0
	opacity = 0
	anchored = 1
	switcher = 1

	load = 25
	close = 0
	var/alert = 0

	New()
		icon_state = "open"
		..()