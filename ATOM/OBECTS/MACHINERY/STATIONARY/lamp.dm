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
		if(src)
			sd_SetLuminosity(5)
		..()
		//lumina()

	proc/nolight()
		if(src)
			sd_SetLuminosity(0)
		..()
		//dark()

	ex_act()
		..()
		sd_SetLuminosity(0)
		sleep(1)
		del(src)

	Move()
		return



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

	brainlamp
		icon_state = "tablelamp2"
		density = 1

/obj/machinery/lamp/process()
	if(charge <= 0)
		nolight()
	else
		light_process()