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

/obj/machinery/mindmachine
	name = "mind write/read machine"
	icon = 'cloning.dmi'
	icon_state = "scanner"
	density = 1
	anchored = 1
	var/mob/occupant
	var/obj/item/ai_module/AIM

	attack_hand()
		var/dat = "<html><head><title>Super mind machine</title></head> \
		<body> \
		<h2>Mind amount: [occupant]</h2></br>\
		<h1><a href='?src=\ref[src];write=[AIM];'>Write</a> [AIM]</h1></br>\
		<h1><a href='?src=\ref[src];read=[occupant];'>Read</a> [occupant]</h1></br>\
		<h1>Eject human <a href='?src=\ref[src];eject=[occupant];'>[occupant]</a></h1></br>\
		<h1>Eject disk <a href='?src=\ref[src];eject=[AIM];'>[AIM]</a></h1></br>"
		dat += "</body></html>"
		usr << browse(dat,"window=mindmachine")

	Topic(href,href_list[])
		if(href_list["write"])
			sleep(2)
			if(AIM)
				if(AIM.client && occupant)
					occupant.client = AIM.client
					if (src.occupant.client)
						src.occupant.client.eye = src.occupant.client.mob
						src.occupant.client.perspective = MOB_PERSPECTIVE
					src.occupant.loc = src.loc
					src.occupant = null
					new /obj/effect/sparks(src.loc)
					sleep(rand(1,3))
					for(var/mob/M in range(5, src))
						M << 'sparks.ogg'
					occupant << "\blue program loading complete"
				else
					if(occupant && AIM)
						world << "debug"
						if (src.occupant.client)
							src.occupant.client.eye = src.occupant.client.mob
							src.occupant.client.perspective = MOB_PERSPECTIVE
						src.occupant.loc = src.loc
						addai(occupant, AIM.ai)
						src.occupant = null
						new /obj/effect/sparks(src.loc)
						sleep(rand(1,3))
						for(var/mob/M in range(5, src))
							M << 'sparks.ogg'
						occupant << "\blue program loading complete"
		if(href_list["read"])
			if(occupant)
				var/obj/item/ai_module/A = new(src.loc)
				A.client = occupant.client
				A.name = "[occupant] mind module"
				if (src.occupant.client)
					src.occupant.client.eye = src.occupant.client.mob
					src.occupant.client.perspective = MOB_PERSPECTIVE
				src.occupant.loc = src.loc
				src.occupant = null
		if(href_list["eject"])
			if(href_list["eject"] == "[occupant]")
				if (src.occupant.client)
					src.occupant.client.eye = src.occupant.client.mob
					src.occupant.client.perspective = MOB_PERSPECTIVE
				src.occupant.loc = src.loc
				src.occupant = null
			if(href_list["eject"] == "[AIM]")
				AIM.loc = src.loc
				AIM = null

	MouseDrop_T(mob/target, mob/user)
		if(src.occupant)
			usr << "\red The mindmachine is full, empty it first!"
			return
		if(!istype(target,/mob/simulated/living/humanoid))
			usr << "\red Error"
			return
		sleep(30)
		if(target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.loc = src
		src.occupant = target