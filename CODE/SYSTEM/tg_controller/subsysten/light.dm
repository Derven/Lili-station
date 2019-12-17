var/datum/controller/subsystem/light/SSlight

/datum/controller/subsystem/light
	name = "light"
	priority = 40
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/light/New()
	NEW_SS_GLOBAL(SSlight)

/datum/controller/subsystem/light/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/light/fire(resumed = 0)
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
			SSobj.processing -= thing
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/objects/Recover()
	processing = SSobj.processing
