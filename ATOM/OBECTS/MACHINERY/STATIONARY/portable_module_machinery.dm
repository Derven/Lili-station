/obj/machinery/portable_machinery
	icon = 'stationobjs.dmi'
	name = "portable machinery"
	icon_state = "portable_machinery"
	density = 1
	anchored = 0
	var/datum/emodule/central/basic_power_controller/socket_1
	var/datum/emodule/central/basic_power_controller/socket_2
	var/datum/emodule/central/basic_power_controller/socket_3

	process()
		socket_1.myprocess()
		socket_2.myprocess()
		socket_3.myprocess()

	New()
		socket_1 = new /datum/emodule/central/basic_power_controller(src)
		socket_2 = new /datum/emodule/central/basic_power_controller(src)
		socket_3 = new /datum/emodule/central/basic_power_controller(src)
		..()