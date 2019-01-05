/obj/machinery/lamp
	power_channel = LIGHT
	idle_power_usage = 100
	icon_state = "lamp"
	switcher = 1
	use_power = 1
	anchored = 1
	var/broken = 0
	luminosity = 0
	var/max_charge = 1000
	load = 5
	var/datum/emodule/central/basic_power_controller/BPC


	New()
		..()
		BPC = new(src)

	emergency
		charge = 0
		icon_state = "emergency_lamp"
		var/datum/emodule/central/nopower_backup_battery/EPB

		attack_hand()
			usr << charge

		New()
			..()
			EPB = new(src)

		process()
			if(!broken)
				if(EPB)
					if(charge <= 0 && !EPB.myprocess())
						nolight()
						icon_state = "emergency_lamp"
					else
						icon_state = "emergency_lamp_an"
						light_process()

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
		sleep(1)
		del(src)

	Move()
		return

/obj/machinery/lamp/wrong

	New()
		..()
		BPC = null

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

	lamp3
		icon_state = "tablelamp3"
		density = 1

/obj/machinery/lamp/process()
	if(!broken)
		if(BPC)
			BPC.myprocess()
		if(charge <= 0 || charge > max_charge)
			nolight()
			if(charge > max_charge)
				new /obj/effect/sparks(src.loc)
				sleep(rand(1,3))
				for(var/mob/B in range(6, src))
					B << ('sparks.ogg')
				broken = 1
				icon_state = "broken_lamp"
		else
			light_process()