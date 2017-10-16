var/datum/controller/subsystem/atmos/SSatmos
/datum/controller/subsystem/atmos
	name = "Air"
	priority = 30
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()


/datum/controller/subsystem/atmos/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/atmos/fire(resumed = 0)
	air_master.process()

/datum/controller/subsystem/objects/Recover()
	processing = SSatmos.processing
