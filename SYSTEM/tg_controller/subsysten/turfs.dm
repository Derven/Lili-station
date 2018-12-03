var/datum/controller/subsystem/turfs/SSturfs
/datum/controller/subsystem/turfs
	name = "Turfs"
	priority = 50
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/turfs/New()
	NEW_SS_GLOBAL(SSturfs)

/datum/controller/subsystem/turfs/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/turfs/fire(resumed = 0)
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
			SSturfs.processing -= thing
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/turfs/Recover()
	processing = SSturfs.processing