var/consolid = 0

/obj/machinery/consol
	name = "consol"
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200
	luminosity = 2
	var/conid = 0

	New()
		..()
		consolid += 1
		conid = consolid

	var
		mystate = "off"

	process()
		sd_SetLuminosity(2)

/obj/machinery/serverbox
	icon = 'stationobjs.dmi'
	name = "communication server"
	icon_state = "serverbox"
	density = 1
	anchored = 1

	process()
		sleep(150)
		for(var/mob/M in range(2, src))
			M.playsoundforme('signal.ogg')


/obj/machinery/consol/arcade
	name = "arcade machine"
	desc = "Does not support Pin ball."
	icon_state = "arcade"
	var/enemy_name = "Space Villian"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set

	New()
		..()
		new /datum/computer/file/computer_program/arcade(src)

/obj/machinery/consol/command
	name = "command"
	anchored = 2
	icon_state = "command"

/obj/machinery/consol/announcement
	name = "announcement"
	anchored = 2
	icon_state = "shuttle"

	attack_hand()
		var/msg = input("Your announce?",
			"Announce")
		if(msg != "")
			sleep(rand(5,8))
			world << "\red <h1>Station announce: [fix255(msg)]</h1>"
			world << 'commandreport.ogg'

/obj/machinery/consol/superterminal
	name = "superterminal"
	anchored = 2
	icon_state = "command"

	attack_hand()
		var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Superterminal:<hr><table class=\"pure-table\"><thead><tr><th>Consol</th><th>Coordinates</th></tr></thead><tbody>"
		var/i = 0
		for(var/obj/machinery/consol/C in world)
			i += 1
			body += "<tr><td>consol #<a href='?src=\ref[src];cid=[C.conid];'>[i]</a></td><td>[C.x];[C.y]</td></tr>"
		body += "</tbody></table><hr><a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];closemepls=1;'>exit</a></html></body>"
		usr << browse(body,"window=computercon;can_close=0")

/obj/machinery/consol/superterminal/Topic(href,href_list[])
	if(href_list["cid"])
		var/con_id = text2num(href_list["cid"])
		for(var/obj/machinery/consol/C in world)
			if(C.conid == con_id)
				C.attack_hand(usr)
	if(href_list["closemepls"] == "1")
		usr << browse(null, "window=computercon")

/obj/machinery/consol/cargo
	name = "cargo"
	anchored = 2
	icon_state = "cargo"

	mining_shuttle
		attack_hand()
			for(var/mob/M in world)
				M << "\red Engines are being prepared..."
			sleep(3)
			send_supply_shuttle()
			for(var/obj/machinery/simple_apc/SA in range(8, src))
				SA.charge = 0
				SA.my_smes.charge = 0
			for(var/turf/T in locate(src.loc.loc.type))
				T.sd_LumReset()

/obj/machinery/consol/shuttle
	name = "cargo"
	anchored = 2
	icon_state = "shuttle"