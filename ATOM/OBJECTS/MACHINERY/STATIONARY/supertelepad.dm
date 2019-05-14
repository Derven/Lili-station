

/obj/machinery/supertelepad
	icon = 'stationobjs.dmi'
	icon_state = "supertelepad"

	proc/sell()
		var/pricesum = 0
		for(var/obj/O in src.loc)
			if(O != src)
				pricesum += O.price
				for(var/obj/O2 in O.contents)
					pricesum += O2.price
				del(O)

		for(var/obj/item/clothing/id/ID in world)
			ID.credits += round(pricesum / ids)

		for(var/mob/M in range(5, src))
			M << pick('chime.ogg')

	attack_hand()
		if(usr.do_after(10))
			sell()