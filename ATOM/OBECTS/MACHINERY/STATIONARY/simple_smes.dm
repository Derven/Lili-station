/obj/machinery/simple_smes
	icon = 'power.dmi'
	icon_state = "smes"
	var/list/obj/machinery/simple_apc/SA = list()
	charge = 100000
	load = 0
	anchored = 1

	New()
		..()
		smes_powernet.Add(src)

	process()
		sleep(1)
		for(var/obj/machinery/simple_apc/sim_apc in SA)
			if(!istype(sim_apc, /obj/machinery/simple_apc/forship))
				load += sim_apc.load

		charge = charge - load

		if(charge < 0)
			charge = 0

		for(var/obj/machinery/simple_apc/sim_apc in SA)
			if(!istype(sim_apc, /obj/machinery/simple_apc/forship))
				sim_apc.charge = charge

		load = 0

	attack_hand()
		usr << "charge [charge]; load [load]; SA [SA.len]"

/obj/machinery/simple_smes/minismes

	process()
		sleep(1)
		for(var/obj/machinery/simple_apc/sim_apc in range(3, src))
			load += sim_apc.load

		charge = charge - load

		if(charge < 0)
			charge = 0

		for(var/obj/machinery/simple_apc/sim_apc in range(3, src))
			sim_apc.charge = charge

		load = 0

	attack_hand()
		usr << "charge [charge]; load [load]; SA [SA.len]"