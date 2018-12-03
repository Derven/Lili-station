/obj/machinery/lamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "lamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 5
	load = 5

	dir_2
		pixel_y = 64

	proc/light_process()
		lumina()

	proc/nolight()
		dark()

	attack_hand()
		world << charge

/obj/machinery/tablelamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "tablelamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 6
	load = 5

/obj/machinery/lamp/process()
	if(charge <= 0)
		nolight()
	else
		light_process()
