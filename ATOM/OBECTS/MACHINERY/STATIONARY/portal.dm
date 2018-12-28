/obj/machinery/portal
	icon = 'stationobjs.dmi'
	icon_state = "portal"
	var/id = 0

	attack_hand()
		for(var/obj/machinery/portal/P in world)
			if(P.id == id && P != src)
				for(var/atom/movable/O in loc)
					if(O != src)
						O.Move(P.loc)