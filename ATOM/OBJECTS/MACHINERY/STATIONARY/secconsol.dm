/obj/machinery/consol/brigdoor_control
	name = "secure airlock control console"
	var/id
	icon = 'stationobjs.dmi'
	icon_state = "sec_consol"
	var/list/control = new/list()

/obj/machinery/consol/brigdoor_control/echair
	name = "execution console"
	icon = 'stationobjs.dmi'

	attack_hand()
		var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Electro chair system consol:<hr><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];action=echair;'>Activate!</a></html></body>"
		usr << browse(body,"window=computer")

/obj/machinery/consol/brigdoor_control/only_flash
	attack_hand()
		var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Brig system consol:<hr><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];action=flasher;'>flasher</a></html></body>"
		usr << browse(body,"window=computer")

/obj/machinery/consol/camera_control
	name = "security camera monitor"
	var/list/camera_list = new/list()
	icon_state = "sec_consol"

var/CAMid = 0

/obj/machinery/camera
	var/id

	New()
		..()
		CAMid += 1
		id = CAMid

/obj/machinery/consol/camera_control/attack_hand()
	var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
	body += "<body>Camera system consol:<hr><table class=\"pure-table\"><thead><tr><th>Camera</th><th>Coordinates</th></tr></thead><tbody>"
	var/i = 0
	for(var/obj/machinery/camera/C in world)
		i += 1
		body += "<tr><td>camera #<a href='?src=\ref[src];cid=[C.id];'>[i]</a></td><td>[C.x];[C.y]</td></tr>"
	body += "</tbody></table><hr><a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];closemepls=1;'>exit</a></html></body>"
	usr << browse(body,"window=computercam;can_close=0")

/obj/machinery/consol/camera_control/Topic(href,href_list[])
	if(usr.check_topic(src))
		if(href_list["cid"])
			var/cam_id = text2num(href_list["cid"])
			for(var/obj/machinery/camera/C in world)
				if(C.id == cam_id)
					usr.client.perspective = EYE_PERSPECTIVE
					usr.client.eye = locate(C.x, C.y, C.z)
		if(href_list["closemepls"] == "1")
			usr.client.perspective = EDGE_PERSPECTIVE
			usr.client.eye = usr.client.mob
			usr << browse(null, "window=computercam")

/obj/machinery/consol/brigdoor_control/attack_hand()
	var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
	body += "<body>Brig system consol:<hr><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];action=door;'>close/open door</a><br><br><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];action=flasher;'>flasher</a></html></body>"
	usr << browse(body,"window=computer")
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
		if("echair")
			for(var/obj/structure/stool/chair/electro/EC in world)
				EC.activate()

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
	name = "printer"
	icon = 'stationobjs.dmi'
	icon_state = "printer"