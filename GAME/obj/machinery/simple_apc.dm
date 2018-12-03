/obj/machinery/simple_apc
	var/obj/machinery/simple_smes/my_smes
	icon = 'power.dmi'
	icon_state = "apc"
	charge = 0
	load = 0
	anchored = 1

	attack_hand()
		world << charge

	New()
		..()
		spawn(3)
			if(!my_smes)
				my_smes = smes_powernet[1]
				my_smes.SA.Add(src)


	process()
		load = 0
		if(charge < 0)
			charge = 0
		for(var/obj/machinery/M in range(7, src))
			if(!istype(M, /obj/machinery/simple_generator) && !istype(M, /obj/machinery/simple_smes) && !istype(M, /obj/machinery/simple_apc))
				load += M.load
				M.charge = charge
