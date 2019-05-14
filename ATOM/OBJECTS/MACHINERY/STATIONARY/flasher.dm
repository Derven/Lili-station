/obj/machinery/flasher
	icon='stationobjs.dmi'
	icon_state = "flasher"
	var/id

	proc/flash_me_please()
		for(var/mob/simulated/living/humanoid/M in range(2, src.loc))
			M.playsoundforme('flash.ogg')
			M << "\red flasher blinds [M] with the flash!"
			M.rest()
			if(M.client)
				M.client.show_map = 0
				sleep(rand(3,9))
				M.client.show_map = 1
				sleep(rand(2,5))
				M.rest()