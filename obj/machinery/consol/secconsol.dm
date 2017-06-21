/obj/machinery/consol

	secconsol
		icon_state = "sec_consol"
		var/data

		attack_hand()
			usr << browse(data,"window=datasec")

		New()
			..()
			data =  "<html><head><title>Консоль управлени&#1103; тюрьмой</title></head><body>"

			for(var/obj/machinery/airlock/brig/briglock/BL in locate(/area/test_area))
				data += "<br><a href='?src=\ref[src];door=[BL.name]'>[BL.name]</a>"
			data += "</body></html>"

		Topic(href,href_list[])
			//if(href_list["enter"] == "yes")
			var/cur_door = href_list["door"]
			for(var/obj/machinery/airlock/brig/briglock/BL in locate(/area/test_area))
				if(BL.name == cur_door)
					var/turf/simulated/floor/T = BL.loc
					if(BL.charge == 0)
						return
					else
						BL.close = !BL.close
						BL.density = BL.close
						BL.opacity = BL.close
						T.blocks_air = BL.close
						BL.icon_state = BL.close ? "close" : "open"
						T.update_air_properties()

/obj/machinery/printer
	icon = 'stationobjs.dmi'
	icon_state = "printer"