var/datum/events/fun


/datum/events
	var/cur_event = "no"
	var/list/eventslist = list("syndi sabotage", "meteor", "no")

	proc/myevents()
		spawn while(1)
			sleep(300)
			cur_event = pick(eventslist)
			world << "\red Current event is [cur_event]!"

			if(cur_event == "meteor")
				var/obj/meteorspawn = pick(meteormarks)
				boom(rand(3,5), meteorspawn.loc)

	New()
		..()
		myevents()
