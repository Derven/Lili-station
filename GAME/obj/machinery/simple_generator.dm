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
		charge = rand(750, 2000)
		for(var/obj/machinery/simple_apc/SA in range(3, src))
			SA.my_smes.charge += charge