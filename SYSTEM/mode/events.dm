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

	plants
		announce = "\red <h3>Biohazard Level 1</h3>"

		activate()
			world << announce
			var/obj/plantmark/P = pick(plantmarks)
			new /obj/plant(P.loc)

	parasite
		announce = "\red <h3>Biohazard Level 3</h3>"

		activate()
			world << announce
			for(var/mob/ghost/G in world)
				G << "\red <h1>If you want to become a parasite, find a green egg at the station and stand on it</h1>"
			var/obj/parasitemark/P = pick(plantmarks)
			new /obj/item/parasite_egg(P.loc)

	mushroom
		announce = "\red <h3>Biohazard Level 2</h3>"

		activate()
			world << announce
			var/obj/plantmark/P = pick(plantmarks)
			new /obj/plant/mushroom(P.loc)


	communications_blackout
		announce = "\red <h3>Communi*cations Bla#ckout!</h3>"

		activate()
			world << announce
			for(var/obj/machinery/radio/mainmachine/M in world)
				M.on = 0

/datum/eventmaster
	proc/global_events()
		while(derven == genius)
			sleep(rand(400,1300))
			if(prob(30))
				var/EBOY = pick(/datum/event/global_alcotrip, /datum/event/poweroff, /datum/event/plants, /datum/event/mushroom, /datum/event/parasite, /datum/event/communications_blackout)
				var/datum/event/EP = new EBOY()
				EP.activate()

	New()
		spawn(25)
			global_events()
		..()