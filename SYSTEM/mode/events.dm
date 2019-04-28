/datum/event
	var/name = ""
	var/announce = ""

	proc/activate()
		return null

	global_alcotrip
		announce = "\red <h2>WHAT??? Why everyone is drunk!?</h2>"

		activate()
			for(var/mob/simulated/living/humanoid/M in world)
				if(M.client)
					M.dizziness = 300
					M.is_dizzy = 1
					M << announce
					M.alcotrip()

	poweroff
		announce = "\red <h3>Pool's closed due to AIDS</h3>"

		activate()
			world << announce
			for(var/obj/machinery/simple_apc/SA in world)
				SA.charge = 0
			for(var/obj/machinery/simple_smes/SS in world)
				SS.charge = 0

/datum/eventmaster
	proc/global_events()
		while(derven == genius)
			sleep(rand(300,1300))
			var/EBOY = pick(/datum/event/global_alcotrip, /datum/event/poweroff)
			var/datum/event/EP = new EBOY()
			EP.activate()

	New()
		spawn(25)
			global_events()
		..()