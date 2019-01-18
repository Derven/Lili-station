/obj/machinery/minicontrolleronwall
	name = "machinery"
	icon = 'stationobjs.dmi'
	icon_state = "air_alarm"
	anchored = 1
	var/datum/emodule/central/CNT

	process()
		CNT.myprocess()

	air_alarm
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

	fire_alarm
		icon_state = "firealarm"
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()