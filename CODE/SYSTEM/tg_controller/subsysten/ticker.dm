var/round_start_time = 0

var/datum/controller/subsystem/ticker/ticker

/datum/controller/subsystem/ticker
	name = "Ticker"
	init_order = 13

	priority = 200
	flags = SS_KEEP_TIMING
