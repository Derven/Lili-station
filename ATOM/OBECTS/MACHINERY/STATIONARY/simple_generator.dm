/obj/machinery/simple_generator
	icon = 'power.dmi'
	icon_state = "generator"
	charge = 10000

	attack_hand()
		for(var/obj/machinery/simple_apc/SA in range(3, src))
			SA.my_smes.charge += charge

/obj/machinery/solar
	charge = 100

	process()
		charge = rand(280, 420)
		for(var/obj/machinery/simple_apc/SA in range(4, src))
			if(prob(45))
				SA.my_smes.charge += rand(130, 180)
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

	battery
		icon = 'stationobjs.dmi'
		icon_state = "collector"
		var/inner_charge = 100000
		var/active = 0

		attack_hand()
			active = !active
			usr << "You turn [active ? "on" : "off"]  backup batteries.[inner_charge]"
			if(active)
				power_generate()



		power_generate()
			if(active)
				while(inner_charge >= 500)
					sleep(rand(2,4))
					inner_charge -= 500
					flick("collector_generate", src)
					for(var/obj/machinery/simple_apc/SA in range(7, src))
						SA.my_smes.charge += 500