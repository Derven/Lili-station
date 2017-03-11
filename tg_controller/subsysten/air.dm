var/datum/controller/subsystem/atmos/SSatmos
/datum/controller/subsystem/atmos
	name = "Air"
	priority = 30
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/atmos/New()
	NEW_SS_GLOBAL(SSatmos)

/datum/controller/subsystem/atmos/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/atmos/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process(wait)
		else
			SSatmos.processing -= thing
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/objects/Recover()
	processing = SSatmos.processing
