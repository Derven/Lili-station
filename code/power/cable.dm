/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)
	var/turf/TB
	if((d1 == direction || d2 == direction) != 1)
		return
	TB = get_step(src, direction)

	for(var/obj/structure/cable/TC in TB)

		if(!TC)
			continue

		if(src == TC)
			continue

		var/fdir = (!direction)? 0 : turn(direction, 180)

		if(TC.d1 == fdir || TC.d2 == fdir)

			if(!netnum)
				var/datum/powernet/PN = powernets[TC.netnum]
				netnum = TC.netnum
				PN = powernets[netnum]
				PN.cables += src
				continue

			if(TC.netnum != netnum)
				var/datum/powernet/PN = powernets[netnum]
				var/datum/powernet/TPN = powernets[TC.netnum]

				PN.merge_powernets(TPN)


/obj/structure/cable/New()
	..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact

	if(level==1) hide(T.intact)


/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()

	for(var/obj/structure/cable/C in loc)


		if(!C)
			continue

		if(C == src)
			continue
		if(netnum == 0)
			var/datum/powernet/PN = powernets[C.netnum]
			netnum = C.netnum
			PN.cables += src
			continue

		var/datum/powernet/PN = powernets[netnum]
		var/datum/powernet/TPN = powernets[C.netnum]

		PN.merge_powernets(TPN)

	for(var/obj/machinery/power/M in loc)

		if(!M)
			continue

		if(!M.netnum)
			var/datum/powernet/PN = powernets[netnum]
			PN.nodes += M
			M.netnum = netnum
			M.powernet = powernets[M.netnum]

		if(M.netnum < 0)
			continue

		var/datum/powernet/PN = powernets[netnum]
		var/datum/powernet/TPN = powernets[M.netnum]

		PN.merge_powernets(TPN)

	for(var/obj/machinery/power/apc/N in loc)

		if(!N)
			continue

		var/obj/machinery/power/M
		M = N.terminal

		if(M.netnum == 0)
			if(netnum == 0)
				continue
			var/datum/powernet/PN = powernets[netnum]
			PN.nodes += M
			M.netnum = netnum
			M.powernet = powernets[M.netnum]
			continue

		var/datum/powernet/PN = powernets[netnum]
		var/datum/powernet/TPN = powernets[M.netnum]

		PN.merge_powernets(TPN)