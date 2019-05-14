/obj/machinery/simple_generator
	icon = 'power.dmi'
	icon_state = "generator"
	charge = 10000

	attack_hand()
		for(var/obj/machinery/simple_apc/SA in range(3, src))
			SA.my_smes.charge += charge

/obj/machinery/solar
	icon = 'stationobjs.dmi'
	icon_state = "solars"
	charge = 100

	process()
		charge = rand(380, 530)
		for(var/obj/machinery/simple_apc/SA in range(4, src))
			if(prob(45))
				SA.my_smes.charge += rand(230, 280)
			else
				SA.my_smes.charge += charge

/obj/machinery/collector
	icon = 'stationobjs.dmi'
	icon_state = "collector"
	anchored = 1
	density = 1

	proc/power_generate()
		charge = rand(2250, 5250)
		flick("collector_generate", src)
		for(var/obj/machinery/simple_apc/SA in range(7, src))
			SA.my_smes.charge += charge

/obj/machinery
	battery
		icon = 'stationobjs.dmi'
		icon_state = "collector"
		var/datum/emodule/central/emergency_power_module/EPM
		var/inner_charge = 100000

		attack_hand()
			world << inner_charge

		New()
			EPM = new(src)
			..()

		process()
			if(EPM && EPM.myprocess() && inner_charge >= 500)
				sleep(rand(2,3))
				inner_charge -= 500
				flick("collector_generate", src)
				for(var/obj/machinery/simple_apc/SA in range(7, src))
					SA.my_smes.charge += 500