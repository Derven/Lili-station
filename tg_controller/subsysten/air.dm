var/datum/controller/subsystem/air_system/SSatmos
datum/controller/subsystem/air_system
	name = "Air"
	priority = 30
	flags = SS_TICKER

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/air_system/New()

datum/controller/subsystem/air_system/stat_entry()
	..("P:[processing.len]")

datum/controller/subsystem/air_system/fire(resumed = 0)
	air_master.process()

/datum/controller/subsystem/objects/Recover()
	processing = SSatmos.processing