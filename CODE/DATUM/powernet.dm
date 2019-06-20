/datum/powernet
	var
		list/cables = list()	// all cables & junctions
		list/nodes = list()		// all APCs & sources
		newload = 0
		load = 0
		newavail = 0
		avail = 0
		viewload = 0
		number = 0
		perapc = 0			// per-apc avilability
		netexcess = 0