/datum/game_mode
	var/name = "invalid"
	var/votable = 1

// Default check win
/datum/game_mode/proc/announce()
	world << "<B>[src] did not define announce()</B>"

/datum/game_mode/proc/pre_setup()
	return

var/datum/game_mode/list/GMDS = list(/datum/game_mode/extended, /datum/game_mode/traitor)
proc/game_mode_begin()
	var/datum/game_mode/GM = pick(GMDS)
	GM = new GM()
	GM.announce()
	GM:post_setup()

//no win
/*
/datum/game_mode/proc/check_win()
	var/list/L = list(  )

	var/area/A = locate(/area/shuttle)

	for(var/mob/M in world)
		if (M.client)
			if (M.stat != 2)
				var/T = M.loc
				if ((T in A))
					L[text("[]", M.rname)] = "shuttle"
				else
					if (istype(T, /obj/machinery/vehicle/pod))
						L[text("[]", M.rname)] = "pod"
					else
						L[text("[]", M.rname)] = "alive"

	if (L.len)
		world << "\blue <B>The game has ended!</B>"
		for(var/I in L)
			var/tem = L[text("[]", I)]
			switch(tem)
				if("shuttle")
					world << text("\t <B><FONT size = 2>[] has left on the shuttle!</FONT></B>", I)
				if("pod")
					world << text("\t <FONT size = 2>[] has fled on an escape pod!</FONT>", I)
				if("alive")
					world << text("\t <FONT size = 1>[] decided to stay on the station.</FONT>", I)
	else
		world << "\blue <B>No one lived!</B>"
	return 1
*/