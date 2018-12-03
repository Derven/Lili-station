var/datum/controller/subsystem/mobs/SSmobs
/datum/controller/subsystem/mobs
	name = "Mobs"
	priority = 50
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/mobs/New()
	NEW_SS_GLOBAL(SSmobs)

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
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
			SSmobs.processing -= thing
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/Recover()
	processing = SSmobs.processing