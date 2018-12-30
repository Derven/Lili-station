/obj/machinery/sleeper
	name = "sleeper"
	icon = 'cloning.dmi'
	icon_state = "scanner"
	density = 0
	anchored = 1

	process()
		..()
		if(length(contents) > 0)
			icon_state = "pod_g"
		else
			icon_state = "scanner"
		sleep(4)
		for(var/mob/simulated/living/M in contents)
			M.heal_brute(rand(10,60))
			M.heal_burn(rand(10,60))

	attack_hand()
		if(length(contents) > 0)
			if(contents.Find(usr))
				for(var/mob/M in src)
					M.Move(src.loc)
					usr << "\blue <B>You starts escaping from the sleeper</B>"
			else
				usr << "\blue <B>The sleeper is already occupied!</B>"
		else
			usr.Move(src)
			usr << "\blue <B>You starts putting yourself into the sleeper</B>"