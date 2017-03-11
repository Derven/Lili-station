proc/start_processing()
	spawn(3)
		for(var/obj/O in world)
			START_PROCESSING(SSobj, O)

	spawn(3)
		for(var/turf/simulated/T in world)
			START_PROCESSING(SSturfs, T)

	spawn(3)
		for(var/datum/air_group/A in world)
			START_PROCESSING(SSatmos, A)