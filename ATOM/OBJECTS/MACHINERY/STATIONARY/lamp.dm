/obj/machinery/light_switcher
	name = "light_switcher"
	var/mystate = 1
	icon_state = "switcher_on"

	attack_hand()
		mystate = !mystate
		switch(mystate)
			if(1)
				for(var/obj/machinery/lamp/LAMP in range(8, src))
					LAMP.switcher = 1
				icon_state = "switcher_on"
			else
				for(var/obj/machinery/lamp/LAMP in range(8, src))
					LAMP.switcher = 0
				icon_state = "switcher_off"

/obj/machinery/lamp
	name = "light"
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "lamp"
	switcher = 1
	use_power = 1
	anchored = 1
	var/broken = 0
	luminosity = 5
	var/max_charge = 1000
	load = 5
	var/datum/emodule/central/basic_power_controller/BPC

	New()
		..()
		charge = 0
		// if this is not an area and is luminous
		if(!isarea(src)&&(luminosity>0))
			spawn(1)			// delay to allow map load
				sd_ApplyLum()

	//attack_hand()
	//	switcher = 0

	emergency
		name = "emergency light"
		charge = 0
		icon_state = "emergency_lamp"
		var/datum/emodule/central/nopower_backup_battery/EPB

		attack_hand()
			usr << charge

		New()
			..()
			EPB = new(src)
			// if this is not an area and is luminous
			if(!isarea(src)&&(luminosity>0))
				spawn(1)			// delay to allow map load
					sd_ApplyLum()

		process()
			if(!broken)
				if(EPB)
					if(charge <= 0 && !EPB.myprocess())
						//nolight()
						icon_state = "emergency_lamp"
					else

						icon_state = "emergency_lamp_an"
						//light_process()

	dir_2
		pixel_y = 64

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/weapon/screwdriver))
			var/datum/emodule/other/basic_power_controller/BP = BPC.other_socket
			var/newmaxcharge = 0
			newmaxcharge = input("Change maximum charge(0-2000)",
			"Your maximum charge",newmaxcharge)
			if(newmaxcharge > 0 && newmaxcharge < 2000)
				BP.max_charge = newmaxcharge


	proc/light_process()
		if(src)
			sd_SetLuminosity(round(charge/200))
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
		// if this is not an area and is luminous
		if(!isarea(src)&&(luminosity>0))
			sd_StripLum()
		..()
		sleep(1)
		del(src)

	Move()
		return

/obj/machinery/lamp/wrong

	New()
		..()
		BPC = null

/obj/machinery/tablelamp
	name = "desk lamp"
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "tablelamp"
	switcher = 1
	use_power = 1
	anchored = 1
	luminosity = 6
	load = 5

	New()
		..()
		if(!isarea(src)&&(luminosity>0))
			spawn(1)			// delay to allow map load
				sd_ApplyLum()

	Del()
		sd_SetLuminosity(0)
		// if this is not an area and is luminous
		if(!isarea(src)&&(luminosity>0))
			sd_StripLum()
		..()

	brainlamp
		name = "lamp?"
		desc = "You're not sure what exactly you're looking at..."
		icon_state = "tablelamp2"
		density = 1

	lamp3
		name = "burning barrel"
		icon_state = "tablelamp3"
		density = 1

	lamp4
		name = "surgery lamp"
		icon_state = "lamp4"
		density = 0
		ignore_ZLEVEL = 1
		pixel_z = 26

/obj/machinery/lamp/process()
	if(!broken)
		if(charge <= 0 || switcher == 0)
			sd_SetLuminosity(0)
		else
			sd_SetLuminosity(4)
