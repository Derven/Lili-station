/obj/machinery/lamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "lamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 0
	load = 5

	dir_2
		pixel_y = 64

	proc/light_process()
		..()
		sd_SetLuminosity(5)
		//lumina()

	proc/nolight()
		..()
		sd_SetLuminosity(0)
		//dark()

	Del()
		sd_SetLuminosity(0)
		..()

/obj/machinery/tablelamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "tablelamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 6
	load = 5

	Del()
		sd_SetLuminosity(0)
		..()

/obj/machinery/lamp/process()
	if(charge <= 0)
		nolight()
	else
		light_process()