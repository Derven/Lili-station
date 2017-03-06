/obj/machinery/lamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "lamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 6
	load = 5

	proc/light_process()
		lumina()

	proc/nolight()
		dark()

/obj/machinery/lamp/process()
	sleep(2)
	if(charge == 0)
		nolight()
	else
		light_process()
