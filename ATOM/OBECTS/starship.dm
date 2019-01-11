/obj/machinery/ionengine
	name = "ionengine"
	icon = 'stationobjs.dmi'
	icon_state = "ionengine"
	var/id = null

	small_engine
		var/obj/machinery/fuelstorage/inner

		attackby(obj/item/O as obj)
			if(istype(O, /obj/item/fuel))
				var/mob/simulated/living/humanoid/H = usr
				H.drop_item_v()
				inner.fuel += 50
				del(O)
		New()
			..()
			inner = new(src)
			inner.fuel = 45

		use_engine()
			if(inner.fuel > 1)
				inner.fuel -= 1
				flick("active_engine",src)
				return 1
			else
				return 0

	proc/use_engine()
		for(var/obj/machinery/fuelstorage/FS in world)
			if(FS.id == id)
				if(FS.fuel > 1)
					for(var/obj/machinery/simple_apc/SA in range(5, src))
						SA.charge += 1000
						FS.fuel -= 1
						FS.FM.myprocess()
					flick("active_engine",src)
					return 1
				else
					return 0


/obj/machinery/fuelstorage
	var/id = null
	var/fuel = 250
	icon = 'stationobjs.dmi'
	icon_state = "fuel"
	var/datum/emodule/central/fuel_module/FM

	attackby(obj/item/O as obj)
		if(istype(O, /obj/item/fuel))
			var/mob/simulated/living/humanoid/H = usr
			H.drop_item_v()
			fuel += 50
			del(O)

	New()
		FM = new(src)
		..()