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