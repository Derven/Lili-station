/obj/machinery/simple_generator
	icon = 'power.dmi'
	icon_state = "generator"
	charge = 10000

	attack_hand()
		for(var/obj/machinery/simple_apc/SA in range(3, src))
			SA.my_smes.charge += charge

/obj/machinery/solar
	charge = 1000

	process()
		charge = rand(250, 400)
		for(var/obj/machinery/simple_apc/SA in range(4, src))
			if(prob(45))
				SA.my_smes.charge += rand(100, 150)
			else
				SA.my_smes.charge += charge

/obj/machinery/collector
	icon = 'stationobjs.dmi'
	icon_state = "collector"

	proc/power_generate()
		charge = rand(2250, 5250)
		flick("collector_generate", src)
		world << charge
		for(var/obj/machinery/simple_apc/SA in range(7, src))
			SA.my_smes.charge += charge