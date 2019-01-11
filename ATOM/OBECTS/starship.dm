/obj/machinery/ionengine
	name = "ionengine"
	icon = 'stationobjs.dmi'
	icon_state = "ionengine"
	var/id = null

	proc/use_engine()
		for(var/obj/machinery/fuelstorage/FS in world)
			if(FS.id == id)
				if(FS.fuel > 1)
					for(var/obj/machinery/simple_apc/SA in range(5, src))
						SA.charge += 1000
						FS.fuel -= 1
					flick("active_engine",src)
					return 1
				else
					return 0


/obj/machinery/fuelstorage
	var/id = null
	var/fuel = 250
	icon = 'stationobjs.dmi'
	icon_state = "fuel"