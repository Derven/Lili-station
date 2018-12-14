var/datum/events/fun


/datum/events
	var/cur_event = "no"
	var/list/eventslist = list("syndi sabotage", "meteor", "no")

	proc/myevents()
		spawn while(1)
			sleep(300)
			cur_event = pick(eventslist)
			world << "\red Current event is [cur_event]!"

	New()
		..()
		myevents()
