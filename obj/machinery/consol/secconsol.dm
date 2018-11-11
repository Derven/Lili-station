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

/obj/machinery/consol/brigdoor_control
	var/id
	icon = 'stationobjs.dmi'
	icon_state = "sec_consol"
	var/list/control = new/list()

/obj/machinery/consol/brigdoor_control/only_flash
	attack_hand()
		var/body = "<html><body>Brig system consol:<hr><a href='?src=\ref[src];action=flasher;'>flasher</a></html></body>"
		usr << browse(body,"window=govno")

/obj/machinery/consol/brigdoor_control/attack_hand()
	var/body = "<html><body>Brig system consol:<hr><a href='?src=\ref[src];action=door;'>close/open door</a><br><a href='?src=\ref[src];action=flasher;'>flasher</a></html></body>"
	usr << browse(body,"window=govno")
/*
mob/verb/debug_start()
	Move(pick(jobmarks))
	radio_arrival()
	lobby.invisibility = 101
	usr << sound(null)
	usr << browse(null, "window=setup")
*/
//client/Topic(href,href_list[])
//	world << href

/obj/machinery/consol/brigdoor_control/Topic(href,href_list[])
	switch(href_list["action"])
		if("door")
			for(var/obj/machinery/airlock/brig/briglock/BL in control)
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
		if("flasher")
			for(var/obj/machinery/flasher/FL in control)
				FL.flash_me_please()

/obj/machinery/consol/brigdoor_control/New()
	..()
	spawn(20)
		for(var/obj/machinery/airlock/brig/briglock/M in world)
			if (M.id == src.id)
				control += M

		for(var/obj/machinery/flasher/F in world)
			if(F.id == src.id)
				control += F

/obj/machinery/printer
	icon = 'stationobjs.dmi'
	icon_state = "printer"