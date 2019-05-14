/obj/machinery/sparker
	name = "Mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'stationobjs.dmi'
	icon_state = "igniter"
	var/id = null
	var/disable = 0
	var/last_spark = 0
	var/base_state = "igniter"
	anchored = 1

/obj/machinery/sparker/New()
	..()

/obj/machinery/sparker/proc/ignite()
	new /obj/effect/sparks(src.loc)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker_button
	icon = 'stationobjs.dmi'
	icon_state = "igniter_button"

	attack_hand()
		for(var/obj/machinery/sparker/SP in range(7,src))
			SP.ignite()