proc/start_processing()


	spawn(3)
		for(var/obj/O in world)
			START_PROCESSING(SSobj, O)

	spawn(3)
		for(var/turf/simulated/T in world)
			START_PROCESSING(SSturfs, T)