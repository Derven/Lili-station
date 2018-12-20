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
	if(!kill_air)
		air_master.current_cycle++
		var/success = air_master.tick() //Changed so that a runtime does not crash the ticker.
		if(!success) //Runtimed.
			air_master.failed_ticks++
			if(air_master.failed_ticks > 5)
				world << "<font color='red'><b>RUNTIMES IN ATMOS TICKER.  Killing air simulation!</font></b>"
				world << air_master.tick_progress
				kill_air = 1
				air_master.failed_ticks = 0
			/*else if (air_master.failed_ticks > 10)
				air_master.failed_ticks = 0*/

/datum/controller/subsystem/objects/Recover()
	processing = SSatmos.processing